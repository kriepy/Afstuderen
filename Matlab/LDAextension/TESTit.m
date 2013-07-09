% TEST
% Hier we plot the BIC


%% this plots the perplexity
load OutcomeExp4_TEST;
D=DataGaus{1};
Plo=[];
for i=1:length(D.Run)
    Per = D.Run{i}.Perpl;
    plo=[];
    for j=1:length(Per);
        if ~isnan(Per(j))
            plo= [plo Per(j)];
        end
    end
    Plo=[Plo mean(plo)];
end
figure(2)
plot(10:5:90,Plo)
