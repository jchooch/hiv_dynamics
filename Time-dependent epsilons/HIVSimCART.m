%%writefile HIVSimCART.m

%% Workspace initiation
clear, format short e, figure(1), clf

%% Establishing constants      

Const = [0.657, 5E9, 0.01, 6E-11, 6E-13, 0.00137, 0.000513442356, 0.27, 557.7, 22, 5E8]; 
%C(1)=gamma, C(2)=K_T, C(3)=d_T, C(4)=beta, C(5)=eta, C(6)=d_L,
%C(7)=alpha_L, C(8)=d_I, C(9)=p, C(10)=c, C(11)=K_L

num_days = 20;   % number of days = number of doses (see below)
tspan = linspace(0,1,100); % second number should be dose interval (e.g. 1 day)  
yinit = [5E9, 100, 0, 1E6, 0];  %T, I, L, V_I, V_NI

%% Solving ODE system

Const_drug = [0.1 * 11.0903548896, 0.2 * 2.3765019031978]; % Z decay rate, R decay rate
yinit_drug = [.3, .3];

DiffFileName = 'HIVDiffDrug';
DE_drug = eval(sprintf('@(t, y, C) %s(t,y,C)', DiffFileName));
[tout_drug, yout_drug] = ode45(@(t,y) DE_drug(t,y,Const_drug), tspan, yinit_drug);

conc = yout_drug./5; %change to concentrations in g/L
conc_Z = conc(:,1)./286.332; %% change to concentration in mol/L
conc_R = conc(:,2)./704.856; %% change to concentration in mol/L

Emax_Z = 1;
EC50_Z = 4e-6;
n_h_Z = 1;

efficacy_Z = (Emax_Z.* conc_Z.^n_h_Z)/(EC50_Z^n_h_Z + conc_Z.^n_h_Z);
efficacy_Z = efficacy_Z(:,1);

Emax_R = 1;
EC50_R = 4e-9;
n_h_R = 3;

efficacy_R = (Emax_R.* conc_R.^n_h_R)/(EC50_R^n_h_R + conc_R.^n_h_R);
efficacy_R = efficacy_R(:,1);

efficacies_Z = repmat(transpose(efficacy_Z), 1, num_days)
efficacies_R = repmat(transpose(efficacy_R), 1, num_days)
efficacies_vec = vertcat(efficacies_Z, efficacies_R)

fulltspan = linspace(0, num_days, length(tspan) * num_days)

DiffFileName = 'HIVDiffCART';
DE = eval(sprintf('@(t, y, C, efficacies) %s(t,y,C,efficacies)', DiffFileName));
[tout, yout] = ode45(@(t,y) DE(t,y,Const,efficacies_vec), fulltspan, yinit);

%% Plot cells

tiledlayout(1,2)
nexttile
plot(tout,yout(:,1),'k-', tout,yout(:,2),'b-', tout,yout(:,3),'g-', 'LineWidth', 1.4)
xlabel('Time (days)', 'FontSize', 16)
ylabel('Number of cells', 'FontSize', 16)
legend('Target cells', 'Infected cells', 'Latent cells', 'FontSize', 16)
title('Cells over time (cART condition)', 'FontSize', 16)

%% Plot virus

nexttile
plot(tout,yout(:,4),'r-', tout,yout(:,5), 'c-', 'LineWidth', 1.4)
xlabel('Time (days)', 'FontSize', 16)
ylabel('Number of virus particles', 'FontSize', 16)
legend('Free infectious virus', 'Free noninfectious virus', 'FontSize', 16)
title('Free virus over time (cART condition)', 'FontSize', 16)

%% Statistics

disp('Total number of infected timesteps (by virus):')
disp(nnz(yout(:,4) > 5.7E5))
utter = ['(Out of ', num2str(length(tout)), ' total timesteps.']
disp(utter)

peak_v = max(yout(:,4))
disp("Peak virus:")
disp(peak_v)
disp('Time to peak:')
find(yout(:,4) == peak_v) % time to peak
