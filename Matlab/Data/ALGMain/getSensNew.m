function Sensors=getSensAll(info,names)
% Return a struct:
% Sensors.nr
%        .fieldName
%        .fieldNr
%        .type
%        .name


for i=1:length(info)
    vec=regexp(info{i},'\s+','split');
    Sensors{i}.nr=str2num(vec{1});
    for j=2:length(vec)
        strng = vec{j};
        switch strng
            case 'bathroom'
                Sensors{i}.fieldName='bathroom';
                Sensors{i}.fieldNr=1;
            case 'kitchen'
                Sensors{i}.fieldName='kitchen';
                Sensors{i}.fieldNr=2;
            case 'bedroom'
                Sensors{i}.field='bedroom';
                Sensors{i}.fieldNr=3;
            case 'living'
                Sensors{i}.field='living';
                Sensors{i}.fieldNr=4;
            case {'hall', 'front'}
                Sensors{i}.field='hall';
                Sensors{i}.fieldNr=5;
            case 'motion'
                Sensors{i}.type='motion';
            case 'reed'
                Sensors{i}.type='reed';
            otherwise
        end
    end
    
    for j=1:length(names)
        nam=regexp(names{j},'\s+','split');
        if str2num(nam{1})==Sensors{i}.nr
            Sensors{i}.name=strjoin(nam(2:end),' ')   %c=sprintf('%s %s',a,b); 
            break
        end
    end
end