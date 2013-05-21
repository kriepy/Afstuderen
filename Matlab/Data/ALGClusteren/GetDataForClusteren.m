function GetDataForClusteren(TS,CG)
% TS is the amount of time slices
% CG is the amount of course grains fields

if nargin<1
    TS=48;
    CG=1;
end

PathDayData = 'C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\Data\DATAMain';
storePath = 'C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\Data\DATAClustered';
load(strcat(PathDayData,'\sepDays.mat'));
if CG==1
    % dan 5 5 5 5 4
end
DL=86400; % amount of seconds on a day
len=DL/TS;


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
        O=zeros(TS,6);
        for j=1:TS
            temp=[];
            go=1;
            while p<=a && go
                time=vec2stamp(dat(p,1:6));
                if time<(threeOclock+j*len)
                    temp=[temp;dat(p,7:8)];
                    p=p+1;
                else
                    go=0;
                end
                
            end
            
            if isempty(temp)
                out = [0 0 0 0 0];
            else
                out = fillSlice(temp,H.Sensors,[],'simple');
            end
            
            
            %hier wordt de tijd aan de data toegevoegd
            if CG
                for c=1:5
                    if (threeOclock+j*len)<(threeOclock+5*c*3600)
                        ti = c;
                        break
                    end
                 end
            else
                ti = j;
            end
            O(j,:)=[out ti];
            
            
            
        end
        H.day{i}.DataForClusters=O;
        
    end
    save(strcat([storePath,'\House',num2str(House{HN}.HouseNr),'ForClustering']),'H');
end


end