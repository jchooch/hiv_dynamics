%%writefile HIVSimDrug.m

%% Workspace initiation
clear, format short e, figure(1), clf

%% Establishing constants      

Const = [11.0903548896, 2.3765019031978]; 
%C(1) = Z decay rate, %C(2)= R decay rate

tspan = linspace(0,1,1000); %days       
yinit = [.3, .3];  %Z, R (mg)

%% Solving ODE system

DiffFileName = 'HIVDiffDrug';
DE = eval(sprintf('@(t, y, C) %s(t,y,C)', DiffFileName));
[tout, yout] = ode45(@(t,y) DE(t,y,Const), tspan, yinit);
conc = yout./5 %change to concentrations in g/L
conc_Z = conc(:,1)./286.332 %% change to concentration in mol/L
conc_R = conc(:,2)./704.856 %% change to concentration in mol/L


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


%% Reyataz Drug Concentration Curve

figure(3), clf
plot(tspan, conc_R, '-k')
xlabel('Time (days)')
ylabel('Concentration of Drug (mg/mL)')
title('Concentration of Reyataz after 300mg Dose')
axis([0,1,0,1e-4])

%% Reyataz Drug Efficacy

Emax_R = 1;
EC50_R = 4e-9; %M
n_h_R = 3;

efficacy_R = (Emax_R.* conc_R.^n_h_R)/(EC50_R^n_h_R + conc_R.^n_h_R);

figure(4),clf
plot(tspan, efficacy_R, '-k')
xlabel('Time (days)')
ylabel('Efficacy of Drug')
title('Efficacy of Reyataz after 300mg Dose')
axis([0,1,0,1])
