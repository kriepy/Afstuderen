function [alpha,beta]=Mstep(Corpus,k)
%% INPUT
% documents:= All documents in one corpus, this is a struct which contains
% the words, phi and gamma matrices
% Corpus.documents(i).words
% Corpus.documents(i).phi:= matrix of size N x k
% Corpus.documents(i).gamma:= vector of size k
% OUTPUT:
% alpha:= a vector of length k
% beta:= a matrix of size k x V


%% Calculating alpha
alpha=NewTon(Corpus);


%% Calculating beta
beta=getBeta(Corpus,k);


