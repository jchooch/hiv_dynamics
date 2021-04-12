%%writefile HIVSimUntr.m

%% Workspace initiation
clear, format short e, figure(1), clf

%% Establishing constants      

% constants consistent with google doc a/o 04.11.2021
Const = [0.657, 5000000000, 0.01, 0.000000000006, 0.000000000000006, 0.00137, 0.000513442356, 0.27, 557.7, 0.01, 5000000]; 
%C(1)=gamma, C(2)=K_T, C(3)=d_T, C(4)=beta, C(5)=eta, C(6)=d_L, C(7)=alpha_L, C(8)=d_I, C(9)=p, C(10)=c, C(11)=K_L

tspan = linspace(0,10,1000);        
yinit = [5000000000, 100, 0, 100000];  %T, I, L, V

%% Solving ODE system

DiffFileName = 'HIVDiffUntr';
DE = eval(sprintf('@(t, y, C) %s(t,y,C)', DiffFileName));
[tout, yout] = ode45(@(t,y) DE(t,y,Const), tspan, yinit);

%% Epsilon curve

%% Plot cells

tiledlayout(1,2)
nexttile
plot(tout,yout(:,1),'k-', tout,yout(:,2),'b-', tout,yout(:,3),'g-')
xlabel('Time (days)')
ylabel('Numbers')
legend('Target cells', 'Infected cells', 'Latent cells')
title('Cells over time (untreated condition)')
%axis([0,12,0,200])

%% Plot virus

nexttile
plot(tout,yout(:,4),'r-')
xlabel('Time (days)')
ylabel('Number')
legend('Free virus')
title('Free virus over time (untreated condition)')
%axis([0,12,0,200])