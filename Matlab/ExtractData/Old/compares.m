function [BB,KK,SS,LL,DD,over]=compares(Sensors,matse)
% this function looks into a timeperiod and counts the amounts of sensors
% that are triggered in all the regions. (B,K,S,L,D)

    over=zeros(1,5);
    [BB,over(1)]=running(Sensors.B,matse);
    [KK,over(2)]=running(Sensors.K,matse);
    [SS,over(3)]=running(Sensors.S,matse);
    [LL,over(4)]=running(Sensors.L,matse);
    [DD,over(5)]=running(Sensors.D,matse);
    
end

function [amtSens,over]=running(vec,matse)
%% SIMPLE
    amtSens=0;
    for i=1:length(vec)
        ili=find(matse(:,7)==vec(i));
        mat=matse(ili,8);
        [a,over]=getTriggers(mat);
        amtSens=amtSens+a;
    end
%% COMPLEX
%     ili=[];
%     for i=1:length(vec)
%         ili=[ili ;find(matse(:,1)==vec(i))];
%     end
%     sensorVec=matse(ili,2);
%     [siz0,~]=size(find(sensorVec==0));
%     [siz1,~]=size(find(sensorVec==1));
%     amtSens=siz1;
%     if siz0==siz1
%         over=0;
%     elseif siz1>siz0
%         over=1;
%     else
%         if matse(ili(end),2)==1
%             over=1;
%         else
%             disp('a sensor has been closed but not been opened')
%             over=0;
%         end
%     end
end

function [val,open]=getTriggers(mat)
    [SizMat,~] = size(mat);
    if SizMat==0
        val=0;
        open=0;
    else
    
        % check the size is odd or even
        mal=mod(SizMat,2);
        if mal==0
            val=SizMat/2;
            open=0;
        else
            if mat(end)==1
                open=1;
                val=ceil(SizMat/2);
            else
                open=0;
                val=floor(SizMat/2);
            end
        end
    end
end

