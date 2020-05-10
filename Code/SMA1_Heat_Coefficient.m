% (c) 2020 Gabriele Gilardi

% Define the heat transfer convection coefficient of SMA1

function h = SMA1_Heat_Coefficient(u)

global ha_1 hb_1 ha_1c hb_1c phase1

T  = u(1,:);     % Temperature [deg]

% Heating phase
if (phase1 == 1)
    ha = ha_1;
    hb = hb_1;
    
% Cooling phase    
elseif (phase1 == 2)
    ha = ha_1c;
    hb = hb_1c;
   
% SMA is off
else
    ha = ha_1c;
    hb = hb_1c;
end

h = ha + hb*T^2;

% End of function
