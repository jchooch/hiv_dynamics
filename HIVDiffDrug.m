%%writefile HIVDiffDrug.m

function dydt = HIVDiffDrug(t, y, C)

dydt = [-C(1) * y(1);
        -C(2) * y(2)]
end

%C(1) = Z decay rate, %C(2)= A decay rate