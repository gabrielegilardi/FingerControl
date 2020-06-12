% Copyright (c) 2020 Gabriele Gilardi

% Define the desired finger time-profile (angular position) 

function A = Finger_Desired_Position(u)

global ProfileType Cd_H Cd_C Cd

% A(1)    desired rotation
% A(2)    SMA1 state: 0 = off, 1 = on
% A(3)    SMA2 state: 0 = off, 1 = on

time = u(1,:);
switch ProfileType
    
    % Time-profile #1:
    % - rotation to -25 degrees using SMA1 (SMA2 used as passive spring)
    % - cool down period (both SMAs used as passive springs)
    % - rotation to -30 degrees using SMA1 (SMA2 used as passive spring)
    case 1
        % Rotation to -25 degrees
        if (time < 5)
            thetaF = -25;     
            SMA1_state = 1;
            SMA2_state = 0;
        end
        % Cool down period
        if (time >= 5 && time < 10)
            thetaF = -40;         % Not used so its value does not matter
            SMA1_state = 0;
            SMA2_state = 0;
        end
        % Rotation to -30 degrees
        if (time >= 10)
            thetaF = -30;
            SMA1_state = 1;
            SMA2_state = 0;
        end

    % Time-profile #2:
    % - rotation to -25 degrees using SMA1 (SMA2 used as passive spring)
    % - rotation to -55 degrees using both SMAs (motion is driven by SMA2
    %   while SMA1 is used to reduce overshooting)
    case 2
        % Rotation to -25 degrees
        if (time < 5)
            thetaF = -25;     
            SMA1_state = 1;
            SMA2_state = 0;
        end
        % Rotation to -55 degrees
        if (time >= 5)
            thetaF = -55;
            SMA1_state = 1;
            SMA2_state = 1;
        end

    otherwise
        disp('No finger desired profile specified')
        disp(' ')
        return
        
end

% Output
A(1) = thetaF*pi/180;
A(2) = SMA1_state;
A(3) = SMA2_state;
if (SMA1_state == 0 && SMA2_state == 0)
    Cd = Cd_C;
else
    Cd = Cd_H;
end

% End of function  
