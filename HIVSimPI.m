%%writefile HIVSimPI.m

%% Workspace initiation
clear, format short e, figure(1), clf

%% Establishing constants

Const = [0.657, 5E9, 0.01, 6E-11, 6E-13, 0.00137, 0.000513442356, 0.27, 557.7, 22, 5E8]; 
%C(1)=gamma, C(2)=K_T, C(3)=d_T, C(4)=beta, C(5)=eta, C(6)=d_L,
%C(7)=alpha_L, C(8)=d_I, C(9)=p, C(10)=c, C(11)=K_L

num_days = 20;   % number of days = number of doses (see below)
tspan = linspace(0,1,100);  % second number should be dose interval (e.g. 1 day)  
yinit = [5E9, 100, 0, 1E6, 0];  %T, I, L, V_I, V_NI, Z (mg), A (mg)

%% Solving ODE system

Const_drug = [11.0903548896, 2.3765019031978];
yinit_drug = [.3, .3];

DiffFileName = 'HIVDiffDrug';
DE_drug = eval(sprintf('@(t, y, C) %s(t,y,C)', DiffFileName));
[tout_drug, yout_drug] = ode45(@(t,y) DE_drug(t,y,Const_drug), tspan, yinit_drug);

conc = yout_drug./5; %change to concentrations in g/L
conc_Z = conc(:,1)./286.332; %% change to concentration in mol/L
conc_A = conc(:,2)./704.856; %% change to concentration in mol/L

Emax_Z = 1;
EC50_Z = 4e-6;
n_h_Z = 1;

efficacy_Z = (Emax_Z.* conc_Z.^n_h_Z)/(EC50_Z^n_h_Z + conc_Z.^n_h_Z);
efficacy_Z = efficacy_Z(:,1);

Emax_A = 1;
EC50_A = 4e-9;
n_h_A = 3;

efficacy_A = (Emax_A.* conc_A.^n_h_A)/(EC50_A^n_h_A + conc_A.^n_h_A);
efficacy_A = efficacy_A(:,1);

efficacies_Z = repmat(transpose(efficacy_Z), 1, num_days)
efficacies_A = repmat(transpose(efficacy_A), 1, num_days)

fulltspan = linspace(0, num_days, length(tspan) * num_days)

DiffFileName = 'HIVDiffPI';
DE = eval(sprintf('@(t, y, C, efficacies) %s(t,y, C, efficacies)', DiffFileName));
[tout, yout] = ode45(@(t,y) DE(t,y,Const,efficacies_A(1,:)), fulltspan, yinit);

%% Plot cells

figure(1)
tiledlayout(1,2)
nexttile
plot(tout,yout(:,1),'k-', tout,yout(:,2),'b-', tout,yout(:,3),'g-')
xlabel('Time (days)')
ylabel('Number')
legend('Target cells', 'Infected cells', 'Latent cells')
title('Cells over time (PI condition)')
%axis([0,12,0,200])

%% Plot virus

nexttile
plot(tout,yout(:,4),'r-', tout,yout(:,5), 'c-')
xlabel('Time (days)')
ylabel('Number')
legend('Free infectious virus', 'Free noninfectious virus')
title('Free virus over time (PI condition)')
ylim([0 inf])

%% Ziagen Drug Concentration Curve

figure(2)
tiledlayout(2,2)
nexttile
plot(tspan, conc_Z, '-k')
xlabel('Time (days)')
ylabel('Concentration of Drug (M)')
title('Concentration of Ziagen after 300mg Dose')
axis([0,1,0,2e-4])

%% Ziagen Drug Efficacy

nexttile
plot(tspan, efficacy_Z, '-k')
xlabel('Time (days)')
ylabel('Efficacy of Drug')
title('Efficacy of Ziagen after 300mg Dose')
axis([0,1,0,1])


%% Atazanavir Drug Concentration Curve

nexttile
plot(tspan, conc_A, '-k')
xlabel('Time (days)')
ylabel('Concentration of Drug (mg/mL)')
title('Concentration of Atzanavir after 300mg Dose')
axis([0,1,0,1e-4])

%% Atazanavir Drug Efficacy

nexttile
plot(tspan, efficacy_A, '-k')
xlabel('Time (days)')
ylabel('Efficacy of Drug')
title('Efficacy of Atazanavir after 300mg Dose')
axis([0,1,0,1])
