%% TEST voor Poisson

%% PERPLEXITY
load OutExp1_2Pois
for HN=1:5
    dd=DataPois{HN}.PerPoisM;
    plot(dd);
    hold on
    
end



%% For the Perplexity
% load OutExp1_2Pois
% ja=[];
% for i=1:length(DataPois{1}.Run)
%     p=[]
%     for j = 1:10
%         p=[p DataPois{1}.Run{i}.Step{j}.L];
%     end
%     
%     ja=[ja ; p];
%     
% end
% plot(ja)

%% for the BIC

% load OutExp1_2Pois
% dd=DataPois{2};
% plot(dd)
% % for HN=1:5
%     DataPois{HN}.   
% end