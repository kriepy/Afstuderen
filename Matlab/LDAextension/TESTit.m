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
load OutcomeExpTimeSlices2;
ts=1:5;
x=2.^(ts-1)*6;
cmap = colormap(hsv(5));
for i=1:length(DataGaus)
    dd=DataGaus{i}.PerGausM;
    plot(x(2:end),dd(2:end),'Color',cmap(i,:))
    hold on
end
hleg = legend('H1, 63 days','H2, 63 days',...
    'H3, 63 days','H4, 63 days','H5, 63 days',...
    'Location','NorthEast');
xlabel('t:=# of timeslices')
ylabel('Perplexity')
