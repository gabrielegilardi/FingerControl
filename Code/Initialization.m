%
% =========================================================================
% Simulation of the biomimetic control of an artificial finger using a 
% co-contracting antagonistic shape memory alloy (SMA) based tendon-driven
% actuation system.
% =========================================================================
%
% Set variable ProfileType to specify the finger desired time-profile. The
% two examples included are:
%
% Time-profile #1 (ProfileType=1):
% - rotation to -25 degrees using SMA1 (SMA2 used as passive spring)
% - cool down period (both SMAs used as passive springs)
% - rotation to -30 degrees using SMA1 (SMA2 used as passive spring)
%
% Time-profile #2 (ProfileType=2):
% - rotation to -25 degrees using SMA1 (SMA2 used as passive spring)
% - rotation to -55 degrees using both SMAs (motion is driven by SMA2
%   while SMA1 is used to reduce overshooting)
%
% (the time-profiles are defined in Finger_Desired_Position.m)

clear

% GLOBAL VARIABLES

% Phase transformation model
global As Af Ms Mf aA bA cA aM bM cM 
global Es1 Ef1 Esave1 Es2 Ef2 Esave2
% Friction model
global Cd Msf VELsf Cd_H Cd_C ratioF       
% Spring model
global Sw Ks1 Ks2 dxE_limit1 dxE_limit2 fact
% Control model
global Kp_H Kp_C dtCtrl_H dtCtrl_C tCtrl_H1 tCtrl_C1 tCtrl_H2 tCtrl_C2
global pDC_H1 pDC_C1  pDC_H2 pDC_C2 pDCmin periodDC Kd_H Kd_C Ki_H Ki_C
global highV lowV phase1 phase2 tRef tiny ProfileType
% Kinematic model
global alpha1 alpha2 dCB1o dCB2o a1 a2 a3 a4 a5 Lw1 Lw2     
% Heat transfer model
global ha_1 hb_1 ha_2 hb_2 ha_1c hb_1c ha_2c hb_2c Tamb

% Define the finger desired time-profile
ProfileType = 1;

% INITIAL DATA
theta0 = -40*(pi/180);      % Initial angular position [rad]
vel0 = 0*(pi/180);          % Initial angular velocity [rad/s]
Lref = 9.17;                % Springs unstretched length [mm]
dXo1 = (17.44-Lref)/1000;   % SMA1 spring initial elongation [m]
dXo2 = (15.48-Lref)/1000;   % SMA2 spring initial elongation [m]
flagSpring = 2;             % Initial static analysis configuration:
                            %   1 = SMA1 spring fixed and no friction
                            %   2 = SMA2 spring fixed and no friction
                            %   any other number = use friction

% CONTROLLER
Kp_H = 8000;        % Gains heating phase
Kd_H = 5000;     
Ki_H = 30;     
dtCtrl_H = 0.0;     % Sampling time heating phase [s]
tCtrl_H1 = 0.0;     % SMA1 initial reference time heating phase [s]
tCtrl_H2 = 0.0;     % SMA2 initial reference time heating phase [s]

Kp_C = 0;           % Gains cooling phase
Kd_C = 0;     
Ki_C = 0;     
dtCtrl_C = 0.0;     % Sampling time cooling phase [s]
tCtrl_C1 = 0.0;     % SMA1 initial reference time cooling phase [s]
tCtrl_C2 = 0.0;     % SMA2 initial reference time cooling phase [s]

highV = 8.0;        % Applied high voltage [V]
lowV  = 0.0;        % Applied low voltage [V]

periodDC = 0.001;   % Duty cycle period [s]
tRef = 0;           % Starting time duty cycle [s]
pDCmin = 0.0;       % Min. acceptable change in duty cycle value [%]
pDC_H1 = 100;       % SMA1 initial value duty cycle heating phase [%]
pDC_C1 = 0;         % SMA1 initial value duty cycle cooling phase [%]
pDC_H2 = 100;       % SMA2 initial value duty cycle heating phase [%]
pDC_C2 = 0;         % SMA2 initial value duty cycle cooling phase [%]

tiny = 1e-5;        % Small number used to verify the condition t = 0

% HEAT TRANSFER MODEL
Tamb = 60;          % Initial (ambient) temperature [deg]

ha_1 = 20.0;        % SMA1 0th order coefficient heating phase
hb_1 = 0.0005;      % SMA1 2nd order coefficient heating phase
ha_1c = 41.0;       % SMA1 0th order coefficient cooling phase
hb_1c = 0.0005;     % SMA1 2th order coefficient cooling  phase

ha_2 = 20.0;        % SMA2 0th order coefficient heating phase
hb_2 = 0.0005;      % SMA2 2nd order coefficient heating phase
ha_2c = 41.0;       % SMA2 0th order coefficient cooling phase
hb_2c = 0.0005;     % SMA2 2th order coefficient cooling  phase

Cp = 322.0;         % Specific heat [Joule/kg deg]
thetaT = 0;         % Thermoelastic tensor (due to the particular SMA
                    % design used)

% PHASE TRANSFORMATION
As = 75.0;          % Austenite starting temperature [deg]
Af = 110.0;         % Austenite final temperature [deg]
Ms = 85.0;          % Martensite starting temperature [deg] 
Mf = 60.0;          % Martensite final temperature [deg] 
aA = pi/(Af-As);    % Curve fitting parameters heating phase
cA = 10.3e6;        
bA = -aA/cA;       
aM = pi/(Ms-Mf);    % Curve fitting parameters cooling phase
cM = 10.3e6;       
bM = -aM/cM; 
Dm = 28.0e9;        % Martensite Young modulus [Pa]
Da = 75.0e9;        % Austenite Young modulus [Pa]

Es1 = 1;            % SMA1 starting martensite fraction
Ef1 = 0;            % SMA1 final martensite fraction
Esave1 = Es1;   
Es2 = 1;            % SMA2 starting martensite fraction
Ef2 = 0;            % SMA2 final martensite fraction
Esave2 = Es2;

D1 = Dm*Esave1 + (1-Esave1)*Da;     % SMA1 initial Young modulus
D2 = Dm*Esave2 + (1-Esave2)*Da;     % SMA2 initial Young modulus 

% WIRE/SPRING GEOMETRIC AND PHYSICAL PROPERTIES
dens  = 6450.0;             % Density [kg/m^3]
epsR1 = 0.023;              % SMA1 max. recovery strain
epsR2 = 0.023;              % SMA2 max. recovery strain
Rw = 8.66;                  % Electric resistence per unit length [Ohm/m]
Dw = 375.0e-6;              % Diameter [m]
Lw1 = 0.385;                % SMA1 undeformed lenght [m]
Lw2 = 0.385;                % SMA2 undeformed lenght [m]
Sw  = pi*Dw^2/4;            % Sectional area
Mw  = dens*pi*(Dw^2)/4;     % Mass per unith length

Ks1 = 140;          % SMA1 spring stiffness [N/m]
Ks2 = 140;          % SMA2 spring stiffness [N/m]
fact = 1;           % Penalty factor to simulate max. extension

dxBand = 1;
dxSlack1 = 7.0;     % SMA1 max. spring deformation wrt initial deform. [mm]
dxSlack2 = 7.0;     % SMA2 max. spring deformation wrt initial deform. [mm]
Ls0 = 9.17;         % Spring unstretched length [mm]

% FINGER GEOMETRIC AND PHYSICAL PROPERTIES
m = 1.5e-2;             % Mass [kg]
Inertia = 4.88e-5;      % Inertia [kgm^2]
bCM = 0.035;            % CM distance from the joint [m]

Cd_H = 0.03;            % Damping coefficient heating phase
Cd_C = 0.09;            % Damping coefficient cooling phase
Msf = 0.011;            % Static friction [Nm]
ratioF = 0*1.2;         % Ratio static/dynamic friction
VELsf = 0*(pi/180);     % Velocity threshold [rad/s]

g = 9.81;       % Gravitational acceleration [m/s^2] (positive down)

% KINEMATIC MODEL
a1 = 12.3/1000;     % Geometric dimensions [m]
a2 =  6.5/1000;
a3 = 14.5/1000;
a4 = 17.5/1000;
a5 =  1.5/1000;
r = sqrt( a1^2 + a3^2);   

Xc1 = -a5;          % SMA1 coordinates reference points
Yc1 = +a1;
Xd1 = +a2;
Yd1 = +a1;

Xc2 = -a4;          % SMA2 coordinates reference points
Yc2 = -a1;
Xd2 = +a2;
Yd2 = -a1;

alpha1 = atan2(a1,a3);          % SMA1 initial position attachment point
Xb1 = r*cos(alpha1+theta0);       
Yb1 = r*sin(alpha1+theta0);

alpha2 = atan2(-a1,a3);         % SMA2 initial position attachment point
Xb2 = r*cos(alpha2+theta0);       
Yb2 = r*sin(alpha2+theta0);

% Initial deformations and initial wire moment arms

% Finger is rotated up or neutral
if (Yb1 >= Yc1)
    % Deformations
    dCB1o = sqrt( (Xb1-Xc1)^2 + (Yb1-Yc1)^2 );
    dCB2o = sqrt( (Xd2-Xc2)^2 + (Yd2-Yc2)^2 ) + sqrt( (Xb2-Xd2)^2 + (Yb2-Yd2)^2 );
    % Wire moment arms
    b1 = abs(Xb1*Yc1-Xc1*Yb1)/dCB1o;
    b2 = abs(Xb2*Yd2-Xd2*Yb2)/( sqrt( (Xb2-Xd2)^2 + (Yb2-Yd2)^2 ) );
    
% Finger is rotated down
else
    % Deformations
    dCB1o = sqrt( (Xd1-Xc1)^2 + (Yd1-Yc1)^2 ) + sqrt( (Xb1-Xd1)^2 + (Yb1-Yd1)^2 );
    dCB2o = sqrt( (Xb2-Xc2)^2 + (Yb2-Yc2)^2 );
    % Wire moment arms
    b1 = abs(Xb1*Yd1-Xd1*Yb1)/( sqrt( (Xb1-Xd1)^2 + (Yb1-Yd1)^2 ) );
    b2 = abs(Xb2*Yc2-Xc2*Yb2)/dCB2o;

end

% INITIAL VALUES (STATIC CONFIGURATION)
Kd1  = D1*Sw/Lw1;           % SMA1 wire stiffness
Kd2  = D2*Sw/Lw2;           % SMA2 wire stiffness

Keq1 = Kd1*Ks1/(Kd1+Ks1);   % SMA1 equivalent stiffness (wire + spring)
Keq2 = Kd2*Ks2/(Kd2+Ks2);   % SMA2 equivalent stiffness (wire + spring)

Deq1 = Keq1*Lw2/Sw;         % SMA1 equivalent Young modulus
Deq2 = Keq2*Lw2/Sw;         % SMA2 equivalent Young modulus

% SMA1 spring fixed (no friction)
if (flagSpring == 1)
    dXs1 = dXo1;
    dXs2 = ( Keq1*(Ks1/Kd1+1)*dXs1*b1 - m*g*bCM*cos(theta0) ) / ( Keq2*(Ks2/Kd2+1)*b2 );
% SMA2 spring fixed (no friction)
elseif (flagSpring == 2)
    dXs2 = dXo2;
    dXs1 = ( Keq2*(Ks2/Kd2+1)*dXs2*b2 + m*g*bCM*cos(theta0) ) / ( Keq1*(Ks1/Kd1+1)*b1 );
% Use friction
else
    dXs1 = dXo1;
    dXs2 = dXo2;
end

dXw1 = dXs1*Ks1/Kd1;        % SMA1 Wire elongation
dXw2 = dXs2*Ks2/Kd2;        % SMA2 Wire elongation

dX1 = dXs1 + dXw1;          % SMA1 total elongation (wire + spring)
dX2 = dXs2 + dXw2;          % SMA2 total elongation (wire + spring)

eps0_1 = dX1/Lw1;           % SMA1 elastic strain (wire + spring)
eps0_2 = dX2/Lw2;           % SMA2 elastic strain (wire + spring)

sigma0_1 = Deq1*eps0_1;     % SMA1 stress (wire + spring)
sigma0_2 = Deq2*eps0_2;     % SMA2 stress (wire + spring)

dxE_limit1 = (dxSlack1 - dxBand) + 1000*dXs1;    % SMA1 max. extension
dxE_limit2 = (dxSlack2 - dxBand) + 1000*dXs2;    % SMA2 max. extension 

% OUTPUT SOME OF THE RESULTS
fprintf('\n                  SMA1            SMA2');
fprintf('\n sigma      %10.4e      %10.4e        [Pa]',sigma0_1,sigma0_2);
fprintf('\n force        %8.3f        %8.3f        [N]',sigma0_1*Sw,sigma0_2*Sw);
fprintf('\n eps          %8.3f        %8.3f        [%%]',100*eps0_1,100*eps0_2);
fprintf('\n dXs          %8.3f        %8.3f        [mm]',1000*dXs1,1000*dXs2);
fprintf('\n dXw          %8.3f        %8.3f        [mm]',1000*dXw1,1000*dXw2);
fprintf('\n dXlimit      %8.3f        %8.3f        [mm]',dxE_limit1,dxE_limit2);
fprintf('\n\n theta        %8.3f  [deg]',theta0*180/pi);
fprintf('\n friction     %8.3f  [Nm]\n\n\n',Msf);

% End of script
