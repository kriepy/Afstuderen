load('CorpusMoreDims3.mat')
delete MoreDims3
fid = fopen('MoreDims3','a');
S=[];
for i=1:length(Corpus.documents)
    a=find(Corpus.documents(i).DaNoBi);
    array=[];
    for j=1:size(a)
        array=[array [' ', num2str(a(j)),':',num2str(Corpus.documents(i).DaNoBi(a(j)))]];
    end
    
    
    st=strcat([array,'\n']);
    
   st=sprintf(st);
    
    fprintf(fid, '%s', st);
end
%S=strcat(S)
%sprintf(S)
%save('complex','S','-ASCII')
fclose(fid);

 d=fmatrix('MoreDims3');



