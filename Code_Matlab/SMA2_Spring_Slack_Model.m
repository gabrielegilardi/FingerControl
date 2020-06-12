% Copyright (c) 2020 Gabriele Gilardi

% Define the equivalent spring describing the elastic behaviour of SMA2

function A = SMA2_Spring_Slack_Model(u)

global Sw Ks2 dxE_limit2 fact Lw2

D    = u(1,:);      % Actual Young modulus
epsE = u(2,:);      % Total elastic strain (wire + spring)

Lw = Lw2;
Ks = Ks2;
dxE_limit = dxE_limit2;

dxE = Lw*epsE;                  % Total elastic deformation (wire + spring)
Kd = D*Sw/Lw;                   % Equivalent wire stiffness
dxEs = 1000*Kd*dxE/(Kd+Ks);     % Spring deformation (in mm)

% Stiffness of the bias spring (as a function of its deformation) 
dx = dxEs - dxE_limit;
if (dx <= 0)
    Ks_new = Ks;
 else
    Ks_new = Ks + cosh(fact*dx) - 1; 
 end
 
Keq = Ks_new*Kd/(Ks_new+Kd);    % Equivalent stiffness (wire + spring)
Deq = Keq*Lw/Sw;                % Equivalent Young modulus (wire + spring)

A(1) = Ks_new;
A(2) = Deq;

% End of function
