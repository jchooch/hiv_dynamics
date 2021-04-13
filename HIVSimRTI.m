%%writefile HIVSimRTI.m

%% Workspace initiation
clear, format short e, figure(1), clf

%% Establishing constants      

% constants consistent with google doc a/o 04.11.2021
Const = [0.657, 5E9, 0.01, 6E-11, 6E-13, 0.00137, 0.000513442356, 0.27, 557.7, 22, 5E8, 0.7];  %swap 0.7 for epsRTI! 
%C(1)=gamma, C(2)=K_T, C(3)=d_T, C(4)=beta, C(5)=eta, C(6)=d_L,
%C(7)=alpha_L, C(8)=d_I, C(9)=p, C(10)=c, C(s11)=K_L, C(12)=epsilon_RTI

tspan = linspace(0,14,1000);        
yinit = [5E9, 100, 0, 1E6];  %T, I, L, V

%% Solving ODE system

DiffFileName = 'HIVDiffRTI';
DE = eval(sprintf('@(t, y, C) %s(t,y,C)', DiffFileName));
[tout, yout] = ode45(@(t,y) DE(t,y,Const), tspan, yinit);

%% Plot cells

tiledlayout(1,2)
nexttile
plot(tout,yout(:,1),'k-', tout,yout(:,2),'b-', tout,yout(:,3),'g-')
xlabel('Time (days)')
ylabel('Number (\mug)')
legend('Target cells', 'Infected cells', 'Latent cells')
title('Cells over time (RTI condition)')
%axis([0,12,0,200])

%% Plot virus

nexttile
plot(tout,yout(:,4),'r-')
xlabel('Time (days)')
ylabel('Number')
legend('Free virus')
title('Free virus over time (RTI condition)')
%axis([0,12,0,200])