%%writefile HIVSimConstPI.m

%% Workspace initiation
clear, format short e, figure(1), clf

%% Establishing constants

Const = [0.657, 5E9, 0.01, 6E-11, 6E-13, 0.00137, 0.000513442356, 0.27, 557.7, 22, 5E8, 0];
%C(1)=gamma, C(2)=K_T, C(3)=d_T, C(4)=beta, C(5)=eta, C(6)=d_L,
%C(7)=alpha_L, C(8)=d_I, C(9)=p, C(10)=c, C(11)=K_L, C(12)=epsilonPI

tspan = linspace(0,20,1000);  % second number should be number of days
yinit = [5E9, 100, 0, 1E6, 0];  %T, I, L, V_I, V_NI

%% Solving ODE system

DiffFileName = 'HIVDiffConstPI';
DE = eval(sprintf('@(t, y, C) %s(t,y, C)', DiffFileName));

for epsRTI = 
    for eps = linspace(0, 1, 11)
    Const(12) = eps;
    [tout, yout] = ode45(@(t,y) DE(t,y,Const), tspan, yinit);
    touts(:, eps*10+1) = tout;
    youts(:, :, eps*10+1) = yout;
end

%% Plot cells

figure(1)
tiledlayout(1,2)
nexttile
plot(touts(:,2),youts(:,1,2),'k-',...
    touts(:,1),youts(:,2,2),'b-',...
    touts(:,1),youts(:,3,2),'g-',...
    touts(:,8),youts(:,1,9),'k--',...
    touts(:,8),youts(:,2,9),'b--',...
    touts(:,8),youts(:,3,9),'g--',...
    'LineWidth',1.2)
xlabel('Time (days)')
ylabel('Number')
legend('Target cells (\epsilon = 0.1)', 'Infected cells (\epsilon = 0.1)', 'Latent cells (\epsilon = 0.1)', ...
    'Target cells (\epsilon = 0.8)', 'Infected cells (\epsilon = 0.8)', 'Latent cells (\epsilon = 0.8)')
title('Cells over time (PI condition)')

%% Plot virus

nexttile
plot(touts(:,2),youts(:,4,2),'r-',...
    touts(:,2),youts(:,5,2),'c-',...
    touts(:,8),youts(:,4,9),'r--',...
    touts(:,8),youts(:,5,9), 'c--',...
    'LineWidth',1.2)
xlabel('Time (days)')
ylabel('Number')
legend('Free infectious virus (\epsilon = 0.1)', 'Free noninfectious virus (\epsilon = 0.1)', 'Free infectious virus (\epsilon = 0.8)', 'Free noninfectious virus (\epsilon = 0.8)')
title('Free virus over time (PI condition)')
ylim([0 inf])
