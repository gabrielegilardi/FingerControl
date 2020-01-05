
% Define the heat transfer convection coefficient of SMA2

function h = SMA2_Heat_Coefficient(u)

global ha_2 hb_2 ha_2c hb_2c phase2

T  = u(1,:);     % Temperature

% Heating phase
if (phase2 == 1)
    ha = ha_2;
    hb = hb_2;

% Cooling phase
elseif (phase2 == 2)
    ha = ha_2c;
    hb = hb_2c;
    
% SMA is off
else
    ha = ha_2c;
    hb = hb_2c;
    
end

h = ha + hb*T^2;

% End of function
