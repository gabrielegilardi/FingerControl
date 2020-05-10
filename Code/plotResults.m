% (c) 2020 Gabriele Gilardi

% Plot the main results

% FIGURE 1 - MAIN RESULTS
hf1 = figure(1); 
set(hf1,'color','white','name','MAIN RESULTS','NumberTitle','off')

% Finger angular position and desired angular position
subplot(3,2,1)
plot(theta_time(:,1),theta_time(:,3),theta_time(:,1),theta_time(:,2))
grid on
xlabel('Time [s]');
ylabel('\theta, \theta_F [deg]')
legend('\theta','\theta_F','Location','best')

% Finger angular velocity
subplot(3,2,2)
plot(theta_time(:,1),theta_time(:,4))
grid on
xlabel('Time [s]');
ylabel('d\theta/dt [deg/s]')

% SMA1 and SMA2 temperature
subplot(3,2,3)
plot(T_time(:,1),T_time(:,2),T_time(:,1),T_time(:,3))
grid on
xlabel('Time [s]');
ylabel('Temperature [\circC]')
legend('T_1','T_2','Location','best');

% SMA1 and SMA2 voltage
subplot(3,2,4)
plot(V_time(:,1),V_time(:,2),V_time(:,1),V_time(:,3))
grid on
xlabel('Time [s]');
ylabel('Voltage [V]')
legend('V_1','V_2','Location','best');
ylim([-1 10])

% SMA1 spring and wire deformations
D = Da + xi_time(:,2)*(Dm-Da);   % Young's coefficient
eps1T = xi_time(:,2)*epsR1;      % Phase transformation strain
eps1E = eps_time(:,2) - eps1T;   % Total elastic strain (wire+spring)
dxE = Lw1*eps1E;                 % Total elastic deformation (wire+spring)
Kd1_time = D.*(Sw/Lw1);          % Equivalent stiffness of the wire
temp = Kd1_time + Ks1_time(:,2);
dxEw1 = Ks1_time(:,2).*(dxE./temp); % Deformation due to the material
dxEs1 = Kd1_time.*(dxE./temp);      % Deformation due to the bias spring

% SMA2 spring and wire deformations
D = Da + xi_time(:,3)*(Dm-Da);   % Young's coefficient
eps2T = xi_time(:,3)*epsR2;      % Phase transformation strain
eps2E = eps_time(:,3) - eps2T;   % Elastic strain (wire)
dxE = Lw2*eps2E;                 % Total elastic deformation (wire)
Kd2_time = D.*(Sw/Lw2);          % Equivalent stiffness of the wire
temp = Kd2_time + Ks2_time(:,2);
dxEw2 = Ks2_time(:,2).*(dxE./temp); % Deformation due to the material
dxEs2 = Kd2_time.*(dxE./temp);      % Deformation due to the bias spring

% SMA1 and SMA2 spring deformation
subplot(3,2,5)
plot(theta_time(:,1),1000*dxEs1,theta_time(:,1),1000*dxEs2)
grid on
xlabel('Time [s]');
ylabel('Spring deformation [mm]')
legend('SMA1','SMA2','Location','best')

% SMA1 and SMA2 wire deformation
subplot(3,2,6)
plot(theta_time(:,1),1000*dxEw1,theta_time(:,1),1000*dxEw2)
grid on
xlabel('Time [s]');
ylabel('Wire deformation [mm]')
legend('SMA1','SMA2','Location','best')

clear hf1 temp

% ----------------

% FIGURE 2: RESULTS SMA1
hf2 = figure(2); 
set(hf2,'color','white','name','RESULTS SMA1','NumberTitle','off')

% Total strain
subplot(3,2,1)
plot(eps_time(:,1),eps_time(:,2)*100)
grid on
xlabel('Time [s]');
ylabel('\epsilon [%]')

% Strain components
subplot(3,2,2)
plot(xi_time(:,1),eps1T*100,xi_time(:,1),eps1E*100)
grid on
xlabel('Time [s]');
ylabel('\epsilon_t, \epsilon_e [%]')
legend('\epsilon_t','\epsilon_e','Location','best')

% Stress and tension force
subplot(3,2,3)
[AX, H1, H2] = plotyy(sigma_time(:,1),sigma_time(:,2),sigma_time(:,1),Sw*sigma_time(:,2));
grid on
xlabel('Time [s]');
set(get(AX(1),'Ylabel'),'String','\sigma [Pa]')
set(get(AX(2),'Ylabel'),'String','F_\sigma [N]')

% Stress-Strain diagram
subplot(3,2,4)
plot(eps_time(:,2)*100,sigma_time(:,2))
hold on
plot(eps_time(1,2)*100,sigma_time(1,2),'bo','MarkerSize',5,'MarkerFaceColor','b')
grid on
xlabel('\epsilon [%]');
ylabel('\sigma [Pa]')
hold off

% Martensite fraction and duty cycle
subplot(3,2,5)
[AX,~,~] = plotyy(xi_time(:,1),xi_time(:,2)*100,pDC_time(:,1),pDC_time(:,2));
grid on
xlabel('Time [s]');
set(get(AX(1),'Ylabel'),'String','\xi [%]')
set(get(AX(2),'Ylabel'),'String','Duty Cycle [%]')
set(AX(1),'YLim',[-10 110])
set(AX(2),'YLim',[-10 110])

% Martensite fraction as a function of temperature (hysteresis diagram)
subplot(3,2,6)
n = length(xi_time(:,1));
Dir = zeros(n,1);
Dira = zeros(n,1);
if ( T_time(2,2) > T_time(1,2) )
    Dir(1) = 1;
else
    Dir(1) = 0;
end
for i = 2:n
    if ( T_time(i,2) > T_time(i-1,2) )
        Dir(i) = 1;
    else
        Dir(i) = 0;
    end
end
idx = 1;
Dira(1) = 1;
is(1) = 1;
for i = 2:n
    if ( Dir(i) ~= Dir(i-1) )
        idx = idx + 1;
        is(idx) = i;
    end
    Dira(i) = idx;
end
is(idx+1) = n;
j1 = is(1);
j2 = is(2)-1;
plot(T_time(j1:j2,2),xi_time(j1:j2,2)*100,'r');
hold on
for i = 2:idx
    j1 = is(i);
    j2 = is(i+1)-1;
    if ( mod(i,2) == 0) 
        plot(T_time(j1:j2,2),xi_time(j1:j2,2)*100,'b');
    else  
        plot(T_time(j1:j2,2),xi_time(j1:j2,2)*100,'r');
    end
end
plot(T_time(1,2),xi_time(1,2)*100,'ro','MarkerSize',5,'MarkerFaceColor','r')
grid on
xlabel('T [\circC]');
ylabel('\xi [%]')
ylim([-10 110])
grid on
hold off

clear hf2 n Dir Dira i idx is j1 j2 AX H1 H2

% ----------------

% FIGURE 3: RESULTS SMA2
hf3 = figure(3); 
set(hf3,'color','white','name','RESULTS SMA2','NumberTitle','off')

% Total strain
subplot(3,2,1)
plot(eps_time(:,1),eps_time(:,3)*100)
grid on
xlabel('Time [s]');
ylabel('\epsilon [%]')

% Strain components
subplot(3,2,2)
plot(xi_time(:,1),eps2T*100,xi_time(:,1),eps2E*100)
grid on
xlabel('Time [s]');
ylabel('\epsilon_t, \epsilon_e [%]')
legend('\epsilon_t','\epsilon_e','Location','best')

% Stress and tension force
subplot(3,2,3)
[AX, H1, H2] = plotyy(sigma_time(:,1),sigma_time(:,3),sigma_time(:,1),Sw*sigma_time(:,3));
grid on
xlabel('Time [s]');
set(get(AX(1),'Ylabel'),'String','\sigma [Pa]')
set(get(AX(2),'Ylabel'),'String','F_\sigma [N]')

% Stress-Strain diagram
subplot(3,2,4)
plot(eps_time(:,3)*100,sigma_time(:,3))
hold on
plot(eps_time(1,3)*100,sigma_time(1,3),'bo','MarkerSize',5,'MarkerFaceColor','b')
grid on
xlabel('\epsilon [%]');
ylabel('\sigma [Pa]')
hold off

% Martensite fraction and duty cycle
subplot(3,2,5)
[AX, H1, H2] = plotyy(xi_time(:,1),xi_time(:,3)*100,pDC_time(:,1),pDC_time(:,3));
grid on
xlabel('Time [s]');
set(get(AX(1),'Ylabel'),'String','\xi [%]')
set(get(AX(2),'Ylabel'),'String','Duty Cycle [%]')

% Martensite fraction as a function of temperature (hysteresis diagram)
subplot(3,2,6)
n = length(xi_time(:,1));
Dir = zeros(n,1);
Dira = zeros(n,1);
if ( T_time(2,3) > T_time(1,3) )
    Dir(1) = 1;
else
    Dir(1) = 0;
end
for i = 2:n
    if ( T_time(i,3) > T_time(i-1,3) )
        Dir(i) = 1;
    else
        Dir(i) = 0;
    end
end
idx = 1;
Dira(1) = 1;
is(1) = 1;
for i = 2:n
    if ( Dir(i) ~= Dir(i-1) )
        idx = idx + 1;
        is(idx) = i;
    end
    Dira(i) = idx;
end
is(idx+1) = n;
j1 = is(1);
j2 = is(2)-1;
plot(T_time(j1:j2,3),xi_time(j1:j2,3)*100,'r');
hold on
for i = 2:idx
    j1 = is(i);
    j2 = is(i+1)-1;
    if ( mod(i,2) == 0) 
        plot(T_time(j1:j2,3),xi_time(j1:j2,3)*100,'b');
    else  
        plot(T_time(j1:j2,3),xi_time(j1:j2,3)*100,'r');
    end
end
plot(T_time(1,3),xi_time(1,3)*100,'ro','MarkerSize',5,'MarkerFaceColor','r')
grid on
xlabel('T [\circC]');
ylabel('\xi [%]')
ylim([-10 110])
grid on
hold off

clear hf3 n Dir Dira i idx is j1 j2 AX H1 H2

% End of script
