__________
LOG

Lowest eta value: (10^{-5}, 10^{-8})

Want, for each condition:
- Peak viral load
- Time to peak viral load

Constants before 12th April:
- Untr: Const = [0.25, 100000000, 0.001, 0.000000001, 0.0000000001, 0.00137, 0.05, 0.39, 850, 0.01, 5000]; 
- PI: Const = [0.25, 100000000, 0.001, 0.000000001, 0.0000000001, 0.00137, 0.05, 0.39, 850, 0.01, 5000, 0.9];
- RTI: Const = [0.25, 100000000, 0.001, 0.000000001, 0.0000000001, 0.00137, 0.05, 0.39, 850, 0.01, 5000, 0.9];
- CART: Const = [0.25, 100000000, 0.001, 0.000000001, 0.0000000001, 0.00137, 0.05, 0.39, 850, 0.01, 5000, 0.9, 0.9];

SimConstPI and DiffConstPI are good.
Still need SimConstRTI, DiffConstRTI, SimConstCART, and DiffConstCART.

___________
TODO

1. Check 5E7 virus as a reasonable threshold for infection window (it doesn't show on the graph).
2. Maybe plot latent cells on log graph separately.
3. Show drug concentration and efficacy curves over the full timespan.
4. Figures and tables side-by-side. Use the latter to explain the former. Reference both in the body. Figures don't have to be huge.
5. For Mechanism of Infection slide, too many figures. Divide up.
6. Get peaks and times to peak for all conditions. (And area under curve, and slope of viral growth curve.)
7. Add additional assumptions to slides.
8. Use constant epsilon simulations to estimate drug decay constants.
	Epsilon PI should be 0.2 or higher.
	Epsilon RTI should be 0.2 or higher.
	Together, they should both be 0.2 or higher.
- Make sure all rate decay coefficents are equal.
- Make sure all new graphs are formatted right.

Key:
	Low epsilon: 0.2 [3]
	High epsilon: 0.8 [9]

								Peak 			T2P (days) 		IW (days)
Untreated						1.1423e+11		2.88			19.84

PI, low epsilon 				9.0221e+10		3.46			19.76
PI, high epsilon 				1.9902e+10		12.98			18.08
PI, time-dependent epsilon 		7.8715e+10 		6.06 			19.38

RTI, low epsilon 				1.1246e+11		3.50			19.76
RTI, high epsilon 				9.5734e+10		14.32			18.12
RTI, time-dependent epsilon 	1.0456e+11 		7.14 			18.47

cART, low epsilons 				8.8685e+10		4.24			19.66
cART, high epsilons 			1000000			0.02			0.04
cART, time-dependent epsilon 	7.8589e+10 		14.14 			16.57