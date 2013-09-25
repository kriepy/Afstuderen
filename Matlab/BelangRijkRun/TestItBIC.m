load OutcomeExp_CompareGaus3
load OutcomeExp_ComparePois3
load OutcomeExp_CompareKmeans3


% GAUS
m=[];
s=[];
for run=1:10
    p=[];
    for cros = 1
    
        p=[p DataGaus{5}.Run{run}.Cros{cros}.Bic];
    
    end
    p(:,isnan(p(1,:)))=[]
    m=[m mean(p)];
    s=[s std(p)]
end
errorbar(5:30:290,m,s,'r')

m=[];
s=[];
for run=1:10
    p=[];
    for cros = 1
    
    p=[p DataPois{5}.Run{run}.Cros{cros}.Bic];
    
    end
    p(:,isnan(p(1,:)))=[]
    m=[m mean(p)];
    s=[s std(p)]
end
hold on
errorbar(5:30:290,m,s,'b')

m=[];
s=[];
for run=1:10
        
    m=[m mean(DataKmeans{2}.Run{run}.Bic)];
    s=[s std(DataKmeans{2}.Run{run}.Bic)];
end
hold on
errorbar(5:30:290,m,s,'g')

axis([0 280 20 180])
xlabel '# of topics'
ylabel 'Perplexity'
