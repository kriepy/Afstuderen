%% Show the outcomes

load('OutcomeExp1Clus.mat')
for HN=1:5
    
    plot(10:5:100,DataClus{HN}.perCLUSm)
    hold on
end