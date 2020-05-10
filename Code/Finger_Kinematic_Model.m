% (c) 2020 Gabriele Gilardi

% Define the finger kinematic model

function A = Finger_Kinematic_Model(u)

global alpha1 alpha2 dCB1o dCB2o a1 a2 a3 a4 a5 Lw1 Lw2

theta  = u(1,:);    % Angular position

% Coordinates of the reference points

r = sqrt( a1^2 + a3^2);   

Xc1 = -a5;      % SMA #1
Yc1 = +a1;
Xd1 = +a2;
Yd1 = +a1;

Xc2 = -a4;      % SMA #2
Yc2 = -a1;
Xd2 = +a2;
Yd2 = -a1;

% Position attachment points

Xb1 = r*cos(alpha1+theta);      % SMA #1
Yb1 = r*sin(alpha1+theta);

Xb2 = r*cos(alpha2+theta);      % SMA #2
Yb2 = r*sin(alpha2+theta);

% Deformations and wire moment arms

% Finger is rotated up or neutral
if (Yb1 >= Yc1)
    % Deformations
    dCB1 = sqrt( (Xb1-Xc1)^2 + (Yb1-Yc1)^2 );
    dCB2 = sqrt( (Xd2-Xc2)^2 + (Yd2-Yc2)^2 ) + sqrt( (Xb2-Xd2)^2 + (Yb2-Yd2)^2 );
    % Wire moment arms
    b1 = abs(Xb1*Yc1-Xc1*Yb1)/dCB1;
    b2 = abs(Xb2*Yd2-Xd2*Yb2)/( sqrt( (Xb2-Xd2)^2 + (Yb2-Yd2)^2 ) );

% Finger is rotated down
else
    % Deformations
    dCB1 = sqrt( (Xd1-Xc1)^2 + (Yd1-Yc1)^2 ) + sqrt( (Xb1-Xd1)^2 + (Yb1-Yd1)^2 );
    dCB2 = sqrt( (Xb2-Xc2)^2 + (Yb2-Yc2)^2 );
    % Wire moment arms
    b1 = abs(Xb1*Yd1-Xd1*Yb1)/( sqrt( (Xb1-Xd1)^2 + (Yb1-Yd1)^2 ) );
    b2 = abs(Xb2*Yc2-Xc2*Yb2)/dCB2;

end

A(1) = (dCB1-dCB1o)/Lw1;    % SMA1 deformation
A(2) = (dCB2-dCB2o)/Lw2;    % SMA2 deformation
A(3) = b1;                  % SMA1 wire moment arm
A(4) = b2;                  % SMA2 wire moment arm

% End of function

