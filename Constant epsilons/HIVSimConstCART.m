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
plot(tout,youts(:,1,3,3),'k-',...
    tout,youts(:,2,3,3),'b-',...
    tout,youts(:,3,3,3),'g-',...
    tout,youts(:,1,9,9),'k--',...
    tout,youts(:,2,9,9),'b--',...
    tout,youts(:,3,9,9),'g--',...
    'LineWidth',1.4)
xlabel('Time (days)','FontSize',16)
ylabel('Number of cells','FontSize',16)
legend('Target cells (\epsilon_{PI} = 0.2, \epsilon_{RTI} = 0.2)',...
    'Infected cells (\epsilon_{PI} = 0.2, \epsilon_{RTI} = 0.2)',...
    'Latent cells (\epsilon_{PI} = 0.2, \epsilon_{RTI} = 0.2)', ...
    'Target cells (\epsilon_{PI} = 0.8, \epsilon_{RTI} = 0.8)',...
    'Infected cells (\epsilon_{PI} = 0.8, \epsilon_{RTI} = 0.8)',...
    'Latent cells (\epsilon_{PI} = 0.8, \epsilon_{RTI} = 0.8)',...
    'FontSize',12)
title('Cells over time (cART condition, constant epsilon)','FontSize',16)

%% Plot virus

nexttile
plot(tout,youts(:,4,3,3),'r-',...
    tout,youts(:,5,3,3),'c-',...
    tout,youts(:,4,9,9),'r--',...
    tout,youts(:,5,9,9), 'c--',...
    'LineWidth',1.4)
xlabel('Time (days)','FontSize',16)
ylabel('Number of virus particles','FontSize',16)
legend('Free infectious virus (\epsilon_{PI} = \epsilon_{RTI} = 0)',...
    'Free noninfectious virus (\epsilon_{PI} = \epsilon_{RTI} = 0)',...
    'Free infectious virus (\epsilon_{PI} = \epsilon_{RTI} = 0.8)',...
    'Free noninfectious virus (\epsilon_{PI} = \epsilon_{RTI} = 0.8)',...
    'FontSize', 16)
title('Free virus over time (cART condition, constant epsilon)','FontSize',16)
ylim([0 inf])

figure(2)
plot(tout,youts(:,4,1,1),'c-',...
    tout,youts(:,4,3,3),'r-',...
    tout,youts(:,4,5,5),'g-',...
    tout,youts(:,4,7,7),'k-',...
    tout,youts(:,4,9,9),'b-',...
    tout,youts(:,4,11,11), 'm-',...
    'LineWidth',1.2)
legend('\epsilon_{PI} = \epsilon_{RTI} = 0.0', '\epsilon_{PI} = \epsilon_{RTI} = 0.2',...
    '\epsilon_{PI} = \epsilon_{RTI} = 0.4', '\epsilon_{PI} = \epsilon_{RTI} = 0.6',...
    '\epsilon_{PI} = \epsilon_{RTI} = 0.8', '\epsilon_{PI} = \epsilon_{RTI} = 1.0')
xlabel('Time (days)','FontSize',16)
ylabel('Number of virus particles','FontSize',16)
title('Free virus over time (RTI condition, constant epsilon)','FontSize',16)
ylim([0 inf])

%% Statistics

disp('Total number of infected timesteps (by virus) with low epsilon:')
disp(nnz(youts(:,4,3,3) > 5.7E5))
utter = ['(Out of ', num2str(length(tout)), ' total timesteps.']
disp(utter)

disp('Total number of infected timesteps (by cells) with low epsilon:')
disp(nnz(youts(:,2,3,3) > 1E9))
utter = ['(Out of ', num2str(length(tout)), ' total timesteps.']
disp(utter)

peak_v = max(youts(:,4,3,3))
disp("Peak virus with low epsilon:")
disp(peak_v)
disp('Time to peak:')
find(youts(:,4,3,3) == peak_v) % time to peak

disp('Total number of infected timesteps (by virus) with high epsilon:')
disp(nnz(youts(:,4,9,9) > 5.7E5))
utter = ['(Out of ', num2str(length(tout)), ' total timesteps.']
disp(utter)

disp('Total number of infected timesteps (by cells) with high epsilon:')
disp(nnz(youts(:,2,9,9) > 1E9))
utter = ['(Out of ', num2str(length(tout)), ' total timesteps.']
disp(utter)

peak_v = max(youts(:,4,9,9))
disp("Peak virus with high epsilon:")
disp(peak_v)
disp('Time to peak:')
find(youts(:,4,9,9) == peak_v) % time to peak
