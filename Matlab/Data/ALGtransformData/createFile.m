function createFile%(houseNr)
% This function creates a data file that can be used in LDA
% The input is a struct and the output a dat file that is stored here.

%%
houseNr=247;
load(strcat(['DataMatlab/House',num2str(houseNr),'.mat']));
fid = fopen(strcat(['DataMatlab\LDAdata',num2str(houseNr)]),'a');



for i=1:length(House.day)
    d=House.documents(i).doc;
    a=sum(d,2);
    in=find(a);
    b=full(a(in))
    st=[]
    for j=1:length(b)
        st=[st [num2str(in(j)), ':', num2str(b(j)), ' ']];
        
    end
    st=[st,'\n']
    st=sprintf(st)
    fprintf(fid, '%s', st);
end

fclose(fid);
