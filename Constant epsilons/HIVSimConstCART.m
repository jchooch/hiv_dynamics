%%writefile HIVSimConstCART.m

%% Workspace initiation
clear, format short e, figure(1), clf

%% Establishing constants      

Const = [0.657, 5E9, 0.01, 6E-11, 6E-13, 0.00137, 0.000513442356, 0.27, 557.7, 22, 5E8, 0, 0];  %
%C(1)=gamma, C(2)=K_T, C(3)=d_T, C(4)=beta, C(5)=eta, C(6)=d_L,
%C(7)=alpha_L, C(8)=d_I, C(9)=p, C(10)=c, C(11)=K_L, C(12)=epsilon_PI,
%C(13)=epsilon_RTI
% epsilon values are just initialisations... see _for_ loops below

tspan = linspace(0,20,1000);        
yinit = [5E9, 100, 0, 1E6, 0];  %T, I, L, V_I, V_NI

%% Solving ODE system

DiffFileName = 'HIVDiffConstCART';
DE = eval(sprintf('@(t, y, C) %s(t,y,C)', DiffFileName));

for epsPI = linspace(0, 1, 11)
    Const(12) = epsPI;
    for epsRTI = linspace(0, 1, 11)
        Const(13) = epsRTI;
        [tout, yout] = ode45(@(t,y) DE(t,y,Const), tspan, yinit);
        youts(:, :, epsPI*10+1, epsRTI*10+1) = yout;
    end
end

%% Plot cells

figure(1)
tiledlayout(1,2)
nexttile
plot(tout,youts(:,1,2,2),'k-',...
    tout,youts(:,2,2,2),'b-',...
    tout,youts(:,3,2,2),'g-',...
    tout,youts(:,1,7,7),'k--',...
    tout,youts(:,2,7,7),'b--',...
    tout,youts(:,3,7,7),'g--',...
    'LineWidth',1.4)
xlabel('Time (days)','FontSize',16)
ylabel('Number','FontSize',16)
legend('Target cells (\epsilon_{PI} = 0.1, \epsilon_{RTI} = 0.1)',...
    'Infected cells (\epsilon_{PI} = 0.1, \epsilon_{RTI} = 0.1)',...
    'Latent cells (\epsilon_{PI} = 0.1, \epsilon_{RTI} = 0.1)', ...
    'Target cells (\epsilon_{PI} = 0.6, \epsilon_{RTI} = 0.6)',...
    'Infected cells (\epsilon_{PI} = 0.6, \epsilon_{RTI} = 0.6)',...
    'Latent cells (\epsilon_{PI} = 0.6, \epsilon_{RTI} = 0.6)',...
    'FontSize',12)
title('Cells over time (cART condition, constant epsilon)','FontSize',16)

%% Plot virus

nexttile
plot(tout,youts(:,4,2,2),'r-',...
    tout,youts(:,5,2,2),'c-',...
    tout,youts(:,4,7,7),'r--',...
    tout,youts(:,5,7,7), 'c--',...
    'LineWidth',1.4)
xlabel('Time (days)','FontSize',16)
ylabel('Number','FontSize',16)
legend('Free infectious virus (\epsilon_{PI} = 0.1, \epsilon_{RTI} = 0.1)',...
    'Free noninfectious virus (\epsilon_{PI} = 0.1, \epsilon_{RTI} = 0.1)',...
    'Free infectious virus (\epsilon_{PI} = 0.6, \epsilon_{RTI} = 0.6)',...
    'Free noninfectious virus (\epsilon_{PI} = 0.6, \epsilon_{RTI} = 0.6)',...
    'FontSize', 16)
title('Free virus over time (cART condition, constant epsilon)','FontSize',16)
ylim([0 inf])