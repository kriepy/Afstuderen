%% TEST IT 2

load OutcomeExp_CompareGaus3
load OutcomeExp_ComparePois3

% GAUS
m=[];
s=[];
for run=1:10
    p=[];
    for cros = 1:10
    p=[p DataGaus{5}.Run{run}.Cros{cros}.Perpl];
    
    end
    m=[m mean(p)];
    s=[s std(p)]
end
errorbar(5:30:290,m,s,'r')

% POIS
m=[];
s=[];
for run=1:10
    p=[];
    for cros = 1:10
    
    p=[p DataPois{5}.Run{run}.Cros{cros}.per];
    
    end
    m=[m mean(p)];
    s=[s std(p)]
end
hold on
errorbar(5:30:290,m,s,'b')
%axis([0 280 20 180])
xlabel '# of topics'
ylabel 'Perplexity'

%% For K-means
load OutcomeExp_CompareKmeans8goed
HN = 5;

m=[];
s=[];
for run=1:10
    p=[];
    for cros = 1:10
    
        p=[p exp(log(5*DataKmeans{HN}.Run{run}.Cros{cros}.Perpl))];
    
    end
    m=[m mean(p)];
    s=[s std(p)]
end
hold on
 errorbar(5:30:290,m,s,'g')
%axis([0 280 20 180])
%plot(m)
xlabel '# of topics'
ylabel 'Perplexity'
%hleg1=legend('LDA-Gaussian','LDA-Poisson','LDA + k-means')
%set(hleg1,'Location','East')
