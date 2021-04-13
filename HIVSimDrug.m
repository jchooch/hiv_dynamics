%% Workspace initiation
clear, format short e, figure(1), clf

%% Establishing constants      

Const = [11.0903548896, 2.3765019031978]; 
%C(1) = Z decay rate, %C(2)= A decay rate

tspan = linspace(0,1,1000); %days       
yinit = [.3, .3];  %Z, A (mg)

%% Solving ODE system

DiffFileName = 'HIVDiffDrug';
DE = eval(sprintf('@(t, y, C) %s(t,y,C)', DiffFileName));
[tout, yout] = ode45(@(t,y) DE(t,y,Const), tspan, yinit);
conc = yout./5 %change to concentrations in g/L
conc_Z = conc(:,1)./286.332 %% change to concentration in mol/L
conc_A = conc(:,2)./704.856 %% change to concentration in mol/L


%% Ziagen Drug Concentration Curve

plot(tspan, conc_Z, '-k')
xlabel('Time (days)')
ylabel('Concentration of Drug (M)')
title('Concentration of Ziagen after 300mg Dose')
axis([0,1,0,2e-4])

%% Ziagen Drug Efficacy

Emax_Z = 1;
EC50_Z = 4e-6;
n_h_Z = 1;

efficacy_Z = (Emax_Z.* conc_Z.^n_h_Z)/(EC50_Z^n_h_Z + conc_Z.^n_h_Z);

figure(2),clf
plot(tspan, efficacy_Z, '-k')
xlabel('Time (days)')
ylabel('Efficacy of Drug')
title('Efficacy of Ziagen after 300mg Dose')
axis([0,1,0,1])


%% Atazanavir Drug Concentration Curve

figure(3), clf
plot(tspan, conc_A, '-k')
xlabel('Time (days)')
ylabel('Concentration of Drug (mg/mL)')
title('Concentration of Atzanavir after 300mg Dose')
axis([0,1,0,1e-4])

%% Atazanavir Drug Efficacy

Emax_A = 1;
EC50_A = 4e-9; %M
n_h_A = 3;

efficacy_A = (Emax_A.* conc_A.^n_h_A)/(EC50_A^n_h_A + conc_A.^n_h_A);

figure(4),clf
plot(tspan, efficacy_A, '-k')
xlabel('Time (days)')
ylabel('Efficacy of Drug')
title('Efficacy of Atazanavir after 300mg Dose')
axis([0,1,0,1])
