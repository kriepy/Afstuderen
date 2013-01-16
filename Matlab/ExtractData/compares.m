function [BB,KK,SS,LL,DD,over]=compares(B,K,S,L,D,matse)
    over=zeros(1,5)
    [BB,over(1)]=running(B,matse);
    [KK,over(2)]=running(K,matse);
    [SS,over(3)]=running(S,matse);
    [LL,over(4)]=running(L,matse);
    [DD,over(5)]=running(D,matse);
    
end

function [amtSens,over]=running(vec,matse)
    ili=[];
    for i=1:length(vec)
        ili=[ili ;find(matse(:,1)==vec(i))]
    end
    sensorVec=matse(ili,2)
    [siz0,~]=size(find(sensorVec==0));
    [siz1,~]=size(find(sensorVec==1));
    amtSens=siz1;
    if siz0==siz1
        over=0;
    elseif siz1>siz0
        over=1;
    else
        if matse(ili(end),2)==1
            over=1;
        else
            disp('a sensor has been closed but not been opened')
            over=0;
        end
    end
end

