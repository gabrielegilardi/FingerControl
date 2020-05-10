% (c) 2020 Gabriele Gilardi

% Define the control signal (voltage) applied to SMA2

function V = SMA2_Control_Signal(u)

global dtCtrl_H dtCtrl_C tCtrl_H2 tCtrl_C2 highV lowV 
global tRef pDC_H2 pDC_C2 periodDC tiny phase2

thetaF   = u(1,:);      % Desired final angle
dTheta   = u(2,:);      % Error
dTheta1  = u(3,:);      % Error time-derivative
dThetaI  = u(4,:);      % Error integral
time     = u(5,:);      % Present time
dir      = u(6,:);      % On/Off flag

theta = thetaF - dTheta;    % Current position

% Check if the reference has changed
if ( (time-tRef) >= periodDC )
    tRef = time;
end

% Update the controllers if necessary

% If heating
if ( (time-tCtrl_H2) >= dtCtrl_H || time < tiny )
    tCtrl_H2 = time;
    pDC_H2 = DutyCycle2(1,dTheta,dTheta1,dThetaI,pDC_H2,time);
end
% If cooling
if ( (time-tCtrl_C2) >= dtCtrl_C || time < tiny )
    tCtrl_C2 = time;
    pDC_C2 = DutyCycle2(2,dTheta,dTheta1,dThetaI,pDC_C2,time);
end

% Determine the voltage

% If heating
dtDC = (pDC_H2/100)*periodDC;
if ( (time-tRef) <= dtDC )
    v_H2 = highV;          
else
    v_H2 = lowV;           
end
if dtDC == 0
    v_H2 = lowV;
end
% If cooling
dtDC = (pDC_C2/100)*periodDC;
if ( (time-tRef) <= dtDC )
    v_C2 = highV;          
else
    v_C2 = lowV;           
end
if dtDC == 0
    v_C2 = lowV;
end

% Determine the actual output
% V(1) = voltage
% V(2) = % duty cycle

% Phase
% 0 Nothing, 1 heating, 2 Cooling

% This SMA drives the motion
phase2 = 0;
V(1) = 0;
V(2) = 0;

if ( (dir == 1) )
    
    % Heating
    if (thetaF <= theta)
        V(1) = v_H2;    
        V(2) = pDC_H2;
        phase2 = 1;
        
    % Cooling
    else
        V(1) = v_C2;
        V(2) = pDC_C2;
        phase2 = 2;
        
    end

end    

% End of function


% Define the duty cycle

function pDC = DutyCycle2(type,dTheta,dTheta1,dThetaI,pDC,time)

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
fact = -1;
pDCnew = fact*(Kp*dTheta + Kd*dTheta1 + Ki*dThetaI);
% Bound result
pDCnew = min(100,pDCnew);        % Max. is 100%
pDCnew = max(0,pDCnew);          % Min. is 0
% Check update frequency
if ( abs(pDCnew-pDC) >= pDCmin  || time < tiny )
    pDC = pDCnew;
end

% End of function
