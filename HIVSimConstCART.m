%%writefile HIVSimConstCART.m

%% Workspace initiation
clear, format short e, figure(1), clf

%% Establishing constants      

Const = [0.25, 100000000, 0.001, 0.000000001, 0.0000000001, 0.00137, 0.05, 0.39, 850, 0.01, 5000, 0, 0];  % 
%C(1)=gamma, C(2)=K_T, C(3)=d_T, C(4)=beta, C(5)=eta, C(6)=d_L,
%C(7)=alpha_L, C(8)=d_I, C(9)=p, C(10)=c, C(11)=K_L, C(12)=epsilon_PI,
%C(13)=epsilon_RTI
% epsilon values are just initialisations... see _for loops_ below

tspan = linspace(0,20,1000);        
yinit = [5E9, 100, 0, 1E6, 0];  %T, I, L, V_I, V_NI

%% Solving ODE system

DiffFileName = 'HIVDiffConstCART';
DE = eval(sprintf('@(t, y, C) %s(t,y,C)', DiffFileName));

for epsPI = linspace(0, 1, 11)
    Const(12) = epsPI
    for epsRTI = linspace(0, 1, 11)
        Const(13) = epsRTI
        [tout, yout] = ode45(@(t,y) DE(t,y,Const), tspan, yinit);
        touts(:, epsPI*10+1, epsRTI*10+1) = tout;
        youts(:, :, epsPI*10+1, epsRTI*10+1) = yout;
    end
end

%% Plot cells

figure(1)
tiledlayout(1,2)
nexttile
plot(touts(:,1,1),youts(:,1,1,1),'k-',...
    touts(:,1,1),youts(:,2,1,1),'b-',...
    touts(:,1,1),youts(:,3,1,1),'g-',...
    touts(:,7,7),youts(:,1,7,7),'k--',...
    touts(:,7,7),youts(:,2,7,7),'b--',...
    touts(:,7,7),youts(:,3,7,7),'g--',...
    'LineWidth',1.2)
xlabel('Time (days)')
ylabel('Number')
legend('Target cells (\epsilon_{PI} = 0, \epsilon_{RTI} = 0)',...
    'Infected cells (\epsilon_{PI} = 0, \epsilon_{RTI} = 0)',...
    'Latent cells (\epsilon_{PI} = 0, \epsilon_{RTI} = 0)', ...
    'Target cells (\epsilon_{PI} = 0.6, \epsilon_{RTI} = 0.6)',...
    'Infected cells (\epsilon_{PI} = 0.6, \epsilon_{RTI} = 0.6)',...
    'Latent cells (\epsilon_{PI} = 0.6, \epsilon_{RTI} = 0.6)')
title('Cells over time (cART condition)')

%% Plot virus

nexttile
plot(touts(:,1,1),youts(:,4,1,1),'r-',...
    touts(:,1,1),youts(:,5,1,1),'c-',...
    touts(:,7,7),youts(:,4,7,7),'r--',...
    touts(:,7,7),youts(:,5,7,7), 'c--',...
    'LineWidth',1.2)
xlabel('Time (days)')
ylabel('Number')
legend('Free infectious virus (\epsilon_{PI} = 0, \epsilon_{RTI} = 0)',...
    'Free noninfectious virus (\epsilon_{PI} = 0, \epsilon_{RTI} = 0)',...
    'Free infectious virus (\epsilon_{PI} = 0.6, \epsilon_{RTI} = 0.6)',...
    'Free noninfectious virus (\epsilon_{PI} = 0.6, \epsilon_{RTI} = 0.6)')
title('Free virus over time (cART condition)')
ylim([0 inf])