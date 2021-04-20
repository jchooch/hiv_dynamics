%%writefile HIVDiffCART.m

function dydt = HIVDiffCART(t, y, C, efficacies)

index = floor(t * 99) + 1;
thisepsilonRTI = efficacies(1, index);
thisepsilonPI = efficacies(2, index);

dydt = [C(1)*y(1)*(1 - (y(1)/C(2))) - C(3)*y(1) - (1 - thisepsilonRTI)*C(4)*y(4)*y(1) - C(5)*y(4)*y(1);  %dT/dt
        (1 - thisepsilonRTI)*C(4)*y(4)*y(1) + C(7)*y(3) - C(8)*y(2);                         %dI/dt
        C(1)*y(3)*(1 - (y(3)/C(11))) + C(5)*y(4)*y(1) - C(6)*y(3) - C(7)*y(3);      %dL/dt
        (1 - thisepsilonPI)*C(9)*y(2) - C(10)*y(4);     %dVi/dt
        thisepsilonPI*C(9)*y(2) - C(10)*y(5)]          %dVni/dt

end

%C(1)=gamma, C(2)=K_T, C(3)=d_T, 
%C(4)=beta, C(5)=eta, C(6)=d_L, 
%C(7)=alpha_L, C(8)=d_I, C(9)=p, 
%C(10)=c, C(11)=K_L
%y(1)=target, y(2)=infected, y(3)=latent, y(4)=virusI, y(5)=virusNI