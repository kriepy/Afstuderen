function d=ClusterIt(House,HouseNr,TS,coarse,V)
% TS is the amount of time slices
% CG is 1 if you want to add
% This function translates the data from House so that it can be clustered and
% then runs the clustered functions


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
            % begin om 3 uur in stappen van 5
            % COARSE GRAIN TIME
            if coarse
                for c=1:5
                    if (threeOclock+j*len)<(threeOclock+5*c*3600)
                        ti = c;
                        break
                    end
                end
                 O(j,:)=[out ti];
            end
            
            
            
            
        end
        H.day{i}.PreClusteredData=O; % dit is geen nul maar een letter O
        PreClus{i}.dat=O;
    end
    p=ClusterData(PreClus,V,coarse);
    H.DicClusters=p.Dic;
    H.Clusters=p.Clusters;
    for i=1:length(H.day)
        H.day{i}.ClusteredData=p.dat{i}.dat;
    end
    if HN==HouseNr
        d=H.day;
    end
    House{HN}=H;
end
path='/home/kristin/UVA/Afstuderen/Afstuderen/Matlab/Data/DATAClustered/'
pa=strcat([path,'Clustered',num2str(V),'TS',num2str(TS),'Coarse', num2str(coarse)]);
save(pa,'House');


end