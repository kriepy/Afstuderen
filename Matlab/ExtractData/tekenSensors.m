function tekenSensors
housenr=253;

data = importdata(strcat('C:\Users\Kristin\UVA\Afstuderen\data\',num2str(housenr),'\sensorreadings.txt'));
info = importdata(strcat('C:\Users\Kristin\UVA\Afstuderen\data\', num2str(housenr),'\sensorinfo.txt'));

unix_time=data(:,1);
date = datevec(unix_time/86400 + datenum(1970,1,1));

monthes=unique(date(:,2));
for i=1:1%length(monthes)
    ind1=find(date(:,2)==monthes(i),1,'first');
    ind2=find(date(:,2)==monthes(i),1,'last');
    mon=date(ind1:ind2,:);
    moda=data(ind1:ind2,2:3);
    days=unique(mon(:,3));
    for j = 1:1%length(days)
        in1=find(mon(:,3)==days(i),1,'first');
        in2=find(mon(:,3)==days(i),1,'last');
        day=mon(in1:in2,:);
        dayda=moda(in1:in2,:);
        
        hours=unique(day(:,4));
        
        for k=1:1%length(hours)
            i1=find(day(:,4)==hours(k),1,'first');
            i2=find(day(:,4)==hours(k),1,'last');
            Hour=day(i1:i2,:)
            hoda=dayda(i1:i2,:)
            ix=find(Hour(:,5)<30,1,'last');
            [v,~]=size(ix)
            if v~=0
                teken=1;
            end
            
            if v==0
                matse=hoda
            else
                matse=hoda(ix+1:end,:)
            end
            vars=unique(matse(:,1));
            for p=1:length(vars)
                inx=find(matse==vars(p))
                figure(p)
                
                matse(inx,2)
                vars(p)
            end
                
            
            %figure(i)
        end
        
    end
end
end