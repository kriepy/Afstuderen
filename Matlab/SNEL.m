%%Script
load OutcomeExp_CompareGaus
dg1 = DataGaus{2}.PerGausM;
sg1 = DataGaus{2}.PerGausS;
load OutcomeExp_CompareGaus2
dg2 = DataGaus{2}.PerGausM;
sg2 = DataGaus{2}.PerGausS;
errorbar(5:15:215,[dg1 dg2],[sg1 sg2])

load OutcomeExp_ComparePois
dp1 = DataPois{2}.PerPoisM;
sp1 = DataPois{2}.PerPoisS;
load OutcomeExp_ComparePois2
dp2 = DataPois{2}.PerPoisM;
sp2 = DataPois{2}.PerPoisS;
hold on
errorbar(5:15:215,[dp1 dp2],[sp1 sp2],'r')