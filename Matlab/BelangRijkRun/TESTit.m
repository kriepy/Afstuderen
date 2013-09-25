%% TEST GAUSSIAN
% All tests that are done for the outcomes of LDA-Gaussian
%% this plots the perplexity
% load OutcomeExp4_TESTHN1;
% H{1}=DataGaus{1};
% load OutcomeExp4_TEST;
% H{2}=DataGaus{2};
% H{3}=DataGaus{3};
% load OutcomeExp4_VanKas;
% H{4}=DataGaus{4};
% H{5}=DataGaus{5};
% 
% cmap = colormap(hsv(5));
% 
% D=H{1};
% Plo=[];
% for i=1:length(D.Run)
%     Per = D.Run{i}.Perpl;
%     plo=[];
%     for j=1:length(Per);
%         if ~isnan(Per(j))
%             plo= [plo Per(j)];
%         end
%     end
%     Plo=[Plo mean(plo)];
% end
% 
% plot(10:5:100,Plo,'Color',cmap(1,:));
% hold on
% for i=2:5
%     dat=H{i}.PerGausM;
%     if length(dat)==20
%         plot(10:5:100,dat(2:end),'Color',cmap(i,:));
%     else
%         plot(10:5:100,dat,'Color',cmap(i,:));
%     end
%     hold on
% end
% hleg = legend('H1, 142 days','H2, 98 days',...
%     'H3, 89 days','H4, 63 days','H5, 73 days',...
%     'Location','NorthEastOutside');
%% For the timeslice experiment
% load OutcomeExpTimeSlices;
% for i=1:length(DataGaus)
%     dd=DataGaus{i}.PerGausM;
%     plot(dd(2:end))
%     hold on
% end

%% 
load OutcomeExp_CompareGaus3
load OutcomeExp_ComparePois3

% GAUS
m=[];
s=[];
for run=1:10
    p=[];
    for cros = 1:10
    p=[p exp(log(DataGaus{5}.Run{run}.Cros{cros}.Perpl)/5)];
    
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
    
    p=[p exp(log(DataPois{5}.Run{run}.Cros{cros}.per)/5)];
    
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
load OutcomeExp_CompareKmeans6
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
hleg1=legend('LDA-Gaussian','LDA-Poisson','LDA + k-means')
set(hleg1,'Location','East')
