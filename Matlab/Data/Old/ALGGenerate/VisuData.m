function VisuData(Corpus,cas)
% this function visualizes the generated data
%Corpus = load('C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\ExtractData\DataMatlab\House247')
if nargin<1
    load Generate\CorpusSimple.mat
    cas=2;
end
figure(2)

switch cas
    case 1
        for i=1:10
            A=sum(Corpus.documents(i).doc,2);
            subplot(5,2,i)
            bar(A)
        end

    case 2
        for i=1:length(Corpus.documents)
            a=sum(Corpus.documents(i).doc,2);
            if mod(i,2)==0
            plot(a(1)+rand/5,a(2)+rand/5,'xg');
            else
                plot(a(1)+rand/5,a(2)+rand/5,'x');
            end
            hold on
        end

        % plot([0 3],[0 27],'-')
        % plot([0 6],[0 24],'-')
         plot([0 10],[10 0],'-r')

end
end

