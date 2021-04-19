%%writefile HIVSimUntr.m

%% Workspace initiation
clear, format short e, figure(1), clf

%% Establishing constants      

% constants consistent with google doc a/o 04.11.2021
Const = [0.657, 5E9, 0.01, 6E-11, 6E-13, 0.00137, 0.000513442356, 0.27, 557.7, 22, 5E8]; 
%C(1)=gamma, C(2)=K_T, C(3)=d_T, C(4)=beta, C(5)=eta, C(6)=d_L, C(7)=alpha_L, C(8)=d_I, C(9)=p, C(10)=c, C(11)=K_L

tspan = linspace(0,20,1000);        
yinit = [5E9, 100, 0, 1E6];  %T, I, L, V

%% Solving ODE system

DiffFileName = 'HIVDiffUntr';
DE = eval(sprintf('@(t, y, C) %s(t,y,C)', DiffFileName));
[tout, yout] = ode45(@(t,y) DE(t,y,Const), tspan, yinit);

%% Peak and time-to-peak

disp('Total number of infected timesteps (by cells):')
disp(nnz(yout(:,2) > 5.7E5))
disp('Total number of infected timesteps (by virus):')
disp(nnz(yout(:,4) > 5.7E5))
utter = ['(Out of ', num2str(length(tout)), ' total timesteps.']
disp(utter)

%peak_i = max(yout(:,2))
%peak_v = max(yout(:,4))
%disp("Peak infected cells:", peak_i) %no idea how to write this but they
%print anyway
%disp("Peak virus:", peak_v)

%window1 = min(find(yout(:,4) > 5.7E5))
%window2 = max(find(yout(:,4) > 5.7E5))

%% Plot cells

tiledlayout(1,2)
nexttile
plot(tout,yout(:,1),'k-', tout,yout(:,2),'b-', tout,yout(:,3),'g-', 'LineWidth', 1.4)
xlabel('Time (days)', 'FontSize', 16)
ylabel('Numbers', 'FontSize', 16)
legend('Target cells', 'Infected cells', 'Latent cells', 'FontSize', 16)
title('Cells over time (untreated condition)', 'FontSize', 16)
%axis([0,12,0,200])

%% Plot virus

nexttile
plot(tout,yout(:,4),'r-', 'LineWidth', 1.4)
xlabel('Time (days)', 'FontSize', 16)
ylabel('Number', 'FontSize', 16)
legend('Free virus', 'FontSize', 16)
title('Free virus over time (untreated condition)', 'FontSize', 16)
%axis([0,12,0,200])