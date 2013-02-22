function VisuResult(d,a,b,k)

% alleen 10 documenten worden gevisualiseert
if nargin <1
%     d=fmatrix('Data\LDAdata254');
%     load a
%     load b
%     k=20;
    k=2;
    b=[1 0;0 1];
    a=[0.5 0.5];
    d{1}.id=[1 2];
    d{1}.cnt=[2 2]
end
cmap=colormap(hsv(k));
y=[0 0 1 1];
for i=1:20
    [gamma,phi] = vbem(d{i},b,a,10); %q:=phi
    %phi=Corpus.documents(i).phi;
    x=[0 1 1 0];
    %[N,~]=size(Corpus.documents(i).phi)
    N=length(d{i}.id)
    for j=1:N
        [~,ind]=max(phi(j,:));
        
        
        figure(1)
        hold on
        fill(x,y,cmap(ind,:));
        x=x+1;
    end
    y=y+1;
end
    
end