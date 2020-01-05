
% Define the martensite fraction of SMA1

function E = SMA1_Martensite_Fraction(u)

global As Af Ms Mf aA bA cA aM bM cM
global Es1 Ef1 Esave1

% - up to As it is all martensite
% - between As and Af is partially martensite and partially austenite
% - after Af is all austenite

phase = u(1,:);     % dT/dt > 0 = heating, dT/dt < 0 = cooling
Temp  = u(2,:);     % Temperature
sigma = u(3,:);     % Stress

% Bounds
Lm = Ms + sigma/cM;
Um = Mf + sigma/cM;
La = Af + sigma/cA;
Ua = As + sigma/cA;

kA = cos( aA*(Temp-As) + bA*sigma );
kM = cos( aM*(Temp-Mf) + bM*sigma );

% Heating phase
if (phase > 0)

    if ( Temp < Ua )
        E = Es1;
    elseif ( (Temp >= Ua) && (Temp <= La) )
        E = (Es1/2)*( kA + 1.0 );
    else
        E = 0.0;
    end

    if (Temp < Lm)
        Ef1 = ( 2*E - (1+kM) ) / (1-kM);
    else
        Ef1 = E;
    end
    
end

% Cooling phase
if (phase < 0)

    if ( Temp > Lm )
        E = Ef1;
    elseif ( (Temp <= Lm) && (Temp >= Um) )
        E = ((1-Ef1)/2)*kM + (1+Ef1)/2;
    else
        E = 1.0;
    end

    if (Temp > Ua)
        Es1 = 2*E /( kA + 1.0 );
    else
        Es1 = E;
    end

end

% If temperature constant martensite fraction does not change
if (phase == 0) 
    E = Esave1;
end

Esave1 = E;

% End of function
