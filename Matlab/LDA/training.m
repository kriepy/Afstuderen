function training

% The nr of house we are looking at, each house nr is a different corpus.
houseNr=247;

%Corpus=House;
load Corpus
close all
%Corpus.alpha=[25;26];
Corpus.beta=[0.8 0.2;0.48 0.52];
%Corpus=;

%% LOAD one Copora
% Corpus.documents(d).doc there are M documents
% Every document doc is a matrix of words. Every word is a colum in this
% matrix with one 1 and the rest 0 of length V. Where V is the length of
% the dictionary.
% Corpus.V is the length of the dictionary
% Corpus.dictionary is a vector of length V and contains all the words
% Corpus.N is the length of the documents

% Corpus.alpha will be a vector of length k
% Corpus.beta will be a matrix of size k x V
% Corpus.documents(d).phi will be a matrix of size N x k
% Corpus.documents(d).gamma willbe a vector of length k



% phi and gamma will be different for every document. Alpha and beta stay
% the same for the whole corpus.

%% Initialize
% The EM algorithm should be initialized. Don't know how.
%for testing it:
%D(1).oc=[eye(5);zeros(5)];
%D(2).oc=[zeros(5),eye(5)];


% the length of the dictionary
V=Corpus.V;

% the amount of iterations
N=30;

% the amount of topics
k=2;

%Corpus.alpha=[5 10]'
%Corpus.beta=[0.9 * ones(1,5) 0.2 * ones(1,5);0.1 * ones(1,5) 0.8 * ones(1,5)]
%Cor.beta=   [0.9 * ones(1,5) 0.2 * ones(1,5);0.1 * ones(1,5) 0.8 * ones(1,5)]
for n=1:N
%% E-STEP
    n


    for i=1:length(Corpus.documents)
        i;
        [Corpus.documents(i).phi,Corpus.documents(i).gamma]=Estep(Corpus.alpha,Corpus.beta,Corpus.documents(i).doc);
    end

%% M-STEP
    
    [Corpus.alpha,Corpus.beta]=Mstep(Corpus,k);
    disp('psi is:')
    disp(Corpus.documents(1).phi)
    disp(Corpus.documents(2).phi)
    disp('En beta is:');
    disp(Corpus.beta)
    disp('And finaly the gamma')
    disp([Corpus.documents(1).gamma Corpus.documents(2).gamma])
    
end


end
