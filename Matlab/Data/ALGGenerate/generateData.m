run

k=2;
V=3;

ai=2;
bi=0.8;


%alpha=[20 20]';
%beta=rand(k,V); % k x V
%beta=[bi*ones(1,ai) (1-bi)*ones(1,V-ai);(1-bi)*ones(1,V-ai) bi*ones(1,ai)];
beta=[1 0.2 0;
    0 0.2 1];
% normalize beta
for i=1:size(beta,1)
    S=sum(beta(i,:));
    beta(i,:)=beta(i,:)/S;
end
thea=0.9;

% er worden 100 documenten gecreerd
for i=1:100
    N=10;%random('poiss',10);
    
    % niet uit beta sampelen, slecht idee
    %theta=betarnd(alpha(1),alpha(2));
    
    theta = abs(mod(i,2)-thea);
    
    
        
    % nu gaan we elk woord in de document bepalen
    doc=[];
    for j=1:N
        z=random('bino',1,theta);
        a=mnrnd(1,beta(z+1,:));
        
        %a=mnrnd(1,beta(z+1,:))
        doc=[doc a'];
    end
    Corpus.documents(i).doc=doc;
    Corpus.documents(i).DaNoBi=sum(doc,2);
    
end
%Corpus.alpha=alpha;
Corpus.beta=beta;
Corpus.V=V;
Corpus.k=k;
Corpus.theta=thea;

fileName = strcat([dataPath,'DATAgenerated\Corpus3wtheta',num2str(thea)]);

delete(fileName);
fid = fopen(fileName,'a');
S=[];
for i=1:length(Corpus.documents)
    a=find(Corpus.documents(i).DaNoBi);
    array=[];
    for j=1:size(a)
        array=[array [' ', num2str(a(j)),':',num2str(Corpus.documents(i).DaNoBi(a(j)))]];
    end
    
    
    st=strcat([array,'\n']);
    
   st=sprintf(st);
    
    fprintf(fid, '%s', st);
end

fclose(fid);
d=fmatrix(fileName);
