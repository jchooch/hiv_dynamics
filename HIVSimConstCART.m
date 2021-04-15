%%writefile HIVSimConstCART.m

%This is the same as HIVSimCART.m at the moment!

%% Workspace initiation
clear, format short e, figure(1), clf

%% Establishing constants      

Const = [0.25, 100000000, 0.001, 0.000000001, 0.0000000001, 0.00137, 0.05, 0.39, 850, 0.01, 5000, 0.9, 0.9];  % 
%C(1)=gamma, C(2)=K_T, C(3)=d_T, C(4)=beta, C(5)=eta, C(6)=d_L,
%C(7)=alpha_L, C(8)=d_I, C(9)=p, C(10)=c, C(11)=K_L, C(12)=epsilon_RTI,
%C(13)=epsilon_PI

tspan = linspace(0,10,1000);        
yinit = [5E9, 100, 0, 1E6, 0];  %T, I, L, V_I, V_NI

%% Solving ODE system

DiffFileName = 'HIVDiffCART';
DE = eval(sprintf('@(t, y, C) %s(t,y,C)', DiffFileName));
[tout, yout] = ode45(@(t,y) DE(t,y,Const), tspan, yinit);

%% Plot cells

tiledlayout(1,2)
nexttile
plot(tout,yout(:,1),'k-', tout,yout(:,2),'b-', tout,yout(:,3),'g-')
xlabel('Time (days)')
ylabel('Number')
legend('Target cells', 'Infected cells', 'Latent cells')
title('Cells over time (cART condition)')
%axis([0,12,0,200])

%% Plot virus

nexttile
plot(tout,yout(:,4),'r-', tout,yout(:,5), 'c-')
xlabel('Time (days)')
ylabel('Number')
legend('Free infectious virus', 'Free noninfectious virus')
title('Free virus over time (cART condition)')
%axis([0,12,0,200])s