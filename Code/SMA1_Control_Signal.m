% Copyright (c) 2020 Gabriele Gilardi

% Define the control signal (voltage) applied to SMA1

function V = SMA1_Control_Signal(u)

global dtCtrl_H dtCtrl_C tCtrl_H1 tCtrl_C1 highV lowV 
global tRef pDC_H1 pDC_C1 periodDC tiny phase1

thetaF   = u(1,:);      % Desired final angle
dTheta   = u(2,:);      % Error
dTheta1  = u(3,:);      % Error time-derivative
dThetaI  = u(4,:);      % Error integral
time     = u(5,:);      % Present time
dir      = u(6,:);      % On/Off flag

theta = thetaF - dTheta;    % Present position

% Check if the reference has changed
if ( (time-tRef) >= periodDC )
    tRef = time;
end

% Update the controllers if necessary

% If heating
if ( (time-tCtrl_H1) >= dtCtrl_H || time < tiny )
    tCtrl_H1 = time;
    pDC_H1 = DutyCycle1(1,dTheta,dTheta1,dThetaI,pDC_H1,time);
end
% If cooling
if ( (time-tCtrl_C1) >= dtCtrl_C || time < tiny )
    tCtrl_C1 = time;
    pDC_C1 = DutyCycle1(2,dTheta,dTheta1,dThetaI,pDC_C1,time);
end

% Determine the voltage

% If heating
dtDC = (pDC_H1/100)*periodDC;
if ( (time-tRef) <= dtDC )
    v_H1 = highV;          
else
    v_H1 = lowV;           
end
if dtDC == 0
    v_H1 = lowV;
end
% If cooling
dtDC = (pDC_C1/100)*periodDC;
if ( (time-tRef) <= dtDC )
    v_C1 = highV;          
else
    v_C1 = lowV;           
end
if dtDC == 0
    v_C1 = lowV;
end

% Determine the actual output
% V(1) = voltage
% V(2) = % duty cycle

% Phase
% 0 Nothing, 1 heating, 2 Cooling

% This SMA drives the motion
phase1 = 0;
V(1) = 0;
V(2) = 0;

if ( (dir == 1) )
    
    % Heating
    if (thetaF >= theta)
        V(1) = v_H1;    
        V(2) = pDC_H1;
        phase1 = 1;
        
    % Cooling
    else
        V(1) = v_C1;
        V(2) = pDC_C1;
        phase1 = 2;
        
    end

end    

% End of function


% Define the duty cycle

function pDC = DutyCycle1(type,dTheta,dTheta1,dThetaI,pDC,time)

global pDCmin tiny Kp_C Kd_C Ki_C Kp_H Kd_H Ki_H

% PID gains

% If heating
if ( type == 1 )
    Kp = Kp_H;
    Kd = Kd_H;
    Ki = Ki_H;

% If cooling    
else
    Kp = Kp_C;
    Kd = Kd_C;
    Ki = Ki_C;
    
end

% PID
fact = 1;
pDCnew = fact*(Kp*dTheta + Kd*dTheta1 + Ki*dThetaI);
% Bound result
pDCnew = min(100,pDCnew);        % Max. is 100%
pDCnew = max(0,pDCnew);          % Min. is 0
% Check update frequency
if ( abs(pDCnew-pDC) >= pDCmin  || time < tiny )
    pDC = pDCnew;
end

% End of function
