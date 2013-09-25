%% Visu Statistiks
% This script run some statistiks on the data
clear all
load ../DATAMain/sepDays.mat
M=[];
S=[];
for HN=1:5
    H=House{HN};
    s{HN}.cnt=[];
    for l=1:length(H.day)
        dat=H.day{l}.data;
        s{HN}.cnt=[s{HN}.cnt size(dat,1)];
    end
    s{HN}.mean=mean(s{HN}.cnt);
    M=[M s{HN}.mean]
    s{HN}.std=std(s{HN}.cnt);
    S=[S s{HN}.std];
end

