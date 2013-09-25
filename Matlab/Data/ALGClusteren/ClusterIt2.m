function H=ClusterIt2(House,HouseNr,TS,coarse,V)
% TS is the amount of time slices
% coarse is 1 if you want to add the coarse grain time.
% This function translates the data from House so that it can be clustered and
% then runs the clustered functions for the given HouseNr
%
% The data that is created is used for all LDA models

if nargin < 1
    load ../DATAMain/sepDays.mat
    HouseNr=1;
    TS=48;
    coarse=2;
    V=6;
end

path='/home/kristin/UVA/Afstuderen/Afstuderen/Matlab/Data/DATAClustered/';

DL=86400; % DayLength: amount of seconds on a day
len=DL/TS;

%% TOT HIER
% for each house
for HN=1:5
    H=House{HN};
    for i=1:length(H.day)
        dag = H.day{i};
        ttemp = datevec(dag.date);
        ttemp(4)=3;
        threeOclock = vec2stamp(ttemp);
        dat=dag.data;
        [a,~]=size(dat);
        p=1;
        % we vullen elke timeslice of each day
        DAT=[];
        for j=1:TS
            temp=[];
            go=1;
            while p<=a && go
                time=vec2stamp(dat(p,1:6));
                if time<(threeOclock+j*len)
                    temp=[temp;dat(p,7:8)]
                    p=p+1;
                else
                    go=0;
                end
                
            end
            
            out = FillTS(temp,length(House{HN}.Sensors))
            
            
            
            
                        %hier wordt de tijd aan de data toegevoegd
            % begin om 3 uur in stappen van 5
            % COARSE GRAIN TIME
            if coarse==1 %coarse grain time
                for c=1:5
                    if (threeOclock+j*len)<(threeOclock+5*c*3600)
                        ti = c;
                        break
                    end
                end
                 out=[out ti];
            elseif coarse ==2 %amount timeslices time
                out=[out j];
            else % no time at all
                out=out;
            end
            
            if ts==0
                DAT=[DAT;length(House{HN}.Sensors)]
            else
                DAT=[DAT;ts]
            end
            
        end
        
    end
end

end

function ts = FillTS(temp,len)

if isempty(temp)
    ts=zeros(1,len)
    return
end



end
    
    
    
    
%     if coarse==0
%         maxa=zeros(1,5);
%     else
%         maxa=zeros(1,6);
%     end
%     for i=1:length(H.day)
%         dag = H.day{i};
%         ttemp = datevec(dag.date);
%         ttemp(4)=3;
%         threeOclock = vec2stamp(ttemp);
%         dat=dag.data;
%         [a,~]=size(dat);
%         p=1; %while p<size Data we run
%         if coarse==0
%             O=zeros(TS,5);
%         else
%             O=zeros(TS,6);
%         end
%         for j=1:TS
%             temp=[];
%             go=1;
%             while p<=a && go
%                 time=vec2stamp(dat(p,1:6));
%                 if time<(threeOclock+j*len)
%                     temp=[temp;dat(p,7:8)];
%                     p=p+1;
%                 else
%                     go=0;
%                 end
%                 
%             end
%             
%             if isempty(temp)
%                 out = [0 0 0 0 0];
%             else
%                 out = fillSlice(temp,H.Sensors,[],'simple');
%             end
%             
%             
%             %hier wordt de tijd aan de data toegevoegd
%             % begin om 3 uur in stappen van 5
%             % COARSE GRAIN TIME
%             if coarse==1 %coarse grain time
%                 for c=1:5
%                     if (threeOclock+j*len)<(threeOclock+5*c*3600)
%                         ti = c;
%                         break
%                     end
%                 end
%                  O(j,:)=[out ti];
%             elseif coarse ==2 %amount timeslices time
%                 O(j,:)=[out j];
%             else % no time at all
%                 O(j,:)=out;
%             end
%             
%             
%             
%             
%         end
%         H.day{i}.PreClusteredData=O; % dit is geen nul maar een letter O
%         PreClus{i}.dat=O;
%         tempMa = max(O,[],1);
%         for la = 1:length(tempMa)
%             if maxa(la)<tempMa(la)
%                 maxa(la)=tempMa(la);
%             end
%         end
%     end
%     p=ClusterData(PreClus,V,coarse,maxa);
%     H.DicClusters=p.Dic;
%     H.Clusters=p.Clusters;
%     for i=1:length(H.day)
%         H.day{i}.ClusteredData=p.dat{i}.dat;
%     end
%     House{HN}=H;
% end
% H=House{HouseNr};
% pa=strcat([path,'Clustered',num2str(V),'TS',num2str(TS),'Coarse', num2str(coarse)]);
% save(pa,'House');


