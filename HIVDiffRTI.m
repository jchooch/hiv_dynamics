%%writefile HIVDiffRTI.m

function dydt = HIVDiffRTI(t, y, C)

dydt = [C(1)*y(1)*(1 - (y(1)/C(2))) - C(3)*y(1) - (1 - y(5))*C(4)*y(4)*y(1) - C(5)*y(4)*y(1);  %dT/dt
        (1 - y(5))*C(4)*y(4)*y(1) + C(7)*y(3) - C(8)*y(2);                         %dI/dt
        C(1)*y(3)*(1 - (y(3)/C(11))) + C(5)*y(4)*y(1) - C(6)*y(3) - C(7)*y(3);      %dL/dt
        C(9)*y(2) - C(10)*y(4);                 %dV/dt
        -C(12) * y(5);                          %dZ/dt
        -C(13) * y(6)]                          %dA/dt

end

%C(1)=gamma, C(2)=K_T, C(3)=d_T, 
%C(4)=beta, C(5)=eta, C(6)=d_L, 
%C(7)=alpha_L, C(8)=d_I, C(9)=p, 
%C(10)=c, C(11)=K_L, 
%C(12) = Z decay rate, C(13) = A decay rate
%y(1)=target, y(2)=infected, y(3)=latent, y(4)=virus
%y(5) = Z conc, %y(6)= A conc