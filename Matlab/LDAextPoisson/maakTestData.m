function d=maakTestData
% TESTSCRIPT om DATA te Creeren

clear all
close all
mu=[1 1 ];
mu2=[9 9 ];
sig=[1 1 ];
sig2=[1 1 ];



for i=1:46
    g=[];
    for j=1:length(mu)
        p=[mu(j)+sig(j)*randn(10,1);mu2(j)+sig2(j)*randn(10,1)];
        g=[g p];
    end
    d{i}.mat=g;
%     plot(d{i}.mat(:,1),d{i}.mat(:,2),'rx')
%     hold on
end

% clear i
% clear j
% clear g
% clear p
end
 %plot(d{1}.mat(:,1),d{1}.mat(:,2),'rx')
