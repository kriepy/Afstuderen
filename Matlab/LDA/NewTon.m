function an=NewTon(Corpus)
% this function uses gamma, alpha and the length of the Corpus M
pl=0;


M=length(Corpus.documents);
an=Corpus.alpha



%% This is plotting the Lowerbound depending on alpha
if pl==1
    [a1,a2]=meshgrid(0.1:0.5:20);
    [em,en]=size(a1);
     L=zeros(em,en);
     for p=1:em
         for q=1:en
            L(p,q)=Low(a1(p,q),a2(p,q),Corpus);
         end
     end
     mesh(a1,a2,L);

    % plot the point in the surface
    hold on
    scatter3(an(1),an(2),Low(an(1),an(2),Corpus))
end
%% calcs a part of the gradient ( will always the same)
gradDeel=zeros(size(an));
for i=1:M
    gala=psi(Corpus.documents(i).gamma)-psi(sum(Corpus.documents(i).gamma));
    gradDeel=gradDeel+gala;
end

%% Newton Iteratie
ao=an;
an=100*ones(size(ao));
while sum(abs(an-ao))>0.0001
    gra=grdnt(ao,gradDeel,M);
    [q,z]=hssn(ao,M);
    b=sum(gra./q)/(1/z+sum(1./q));
    for i=1:length(ao)
        an(i)=ao(i)-((gra(i)-b)/q(i));
        if an(i)<=0
            disp('I got in a negative alpha')
            an(i)=0.1;
        end
    end
    if pl==1
        scatter3(an(1),an(2),Low(an(1),an(2),Corpus))
    end
    
    ao=an;
end
an
disp('The differnce between the two alphas is:')
disp(an(2)-an(1))

end

function g=grdnt(alpha,gradDeel,M)
    g=M*(psi(sum(alpha))-psi(alpha))+gradDeel;
end

function [q,z]=hssn(alpha,M)
    z=M*psi(1,sum(alpha));
	q=-M*psi(1,alpha);

end


%% OLD
% itN=0;
% ao=an;
% an=ao-inv(hssn(ao,M))*grdnt(ao,gradDeel,M);
% while sum(abs(an-ao))>0.0001
%     scatter3(an(1),an(2),Low(an(1),an(2),Corpus))
%     itN=itN+1
%     ao=an;
%     
%     an=ao-inv(hssn(ao,M))*grdnt(ao,gradDeel,M);
% end
% 
% 
% 
% end
% 
% function g=grdnt(alpha,gradDeel,M)
%     g=M*(psi(sum(alpha))-psi(alpha))+gradDeel;
% end
% 

