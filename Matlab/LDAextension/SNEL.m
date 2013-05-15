%SNELTEST
% for i=1:length(LDAout)
%     LDAout{i}.likeli
% end

%% ALG. TEST op real DATA
addpath C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\Data\ALGtranExtData
d=transExtData;


m=[];
for i=1:length(d)
    m=[m;max(d{i}.mat)];
end
m=max(m,[],1);


cnt=1;
for k=3:10
    for j=1:10
        for t=1:5 %voor elke run 5 keer testen
            beta.mu=[];
            for i=1:length(m)
                beta.mu=[beta.mu;m(i)*rand(1,k)];
            end
            beta.sigma=j*ones(length(m),k);
            
            [a,b,l]=ldaExtension(d,k,beta);
            LDAout{cnt}.alpha=a;
            LDAout{cnt}.beta=b;
            LDAout{cnt}.likeli=l;
            cnt=cnt+1;
        end
    end
end

%% BANALE TEST
% twee clusters maken met dimensie 2
% maakTestData
% 
% k=2;
% l=2;
% 
% b.mu=[5 5;4 5]
% b.sigma=1*ones(l,k);
% [alpha,beta] = ldaExtension(d,k,b)
% beta.mu

%% 
% A=[];
% B=[];
% for mu1=-1:10
%     atemp=[];
%     btemp=[];
%     for mu2=-1:10
%         b.mu=[mu1 mu2;mu1 mu2]
%         b.sigma=1*ones(2,2);
%         [alpha,beta] = ldaExtension(d,3,b)
%         atemp=[atemp alpha];
%         btemp=[btemp beta];
%     end
%     A=[A; atemp];
%     B=[B; btemp];
% end

