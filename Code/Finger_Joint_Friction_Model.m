% (c) 2020 Gabriele Gilardi

% Define the finger friction model (Coulomb's model + viscous damping)

function M = Finger_Joint_Friction_Model(u)

global Cd Msf VELsf ratioF

Mdf = ratioF*Msf;   % Ratio static/dynamic friction

Mext = u(1,:);      % Total external torque applied to the system
vel  = u(2,:);      % Finger angular velocity

% External torque smaller than static friction and angular velocity
% smaller than velocity threshold (no motion)
if ( abs(vel) <= VELsf && abs(Mext) <= Msf )
    M(1) = 0.0;

% Coulomb's model + viscous damping
else
    Mtemp = Mdf + Cd*abs(vel);
    M(1) = Mext - sign(vel)*Mtemp;
    
end

% End of function
