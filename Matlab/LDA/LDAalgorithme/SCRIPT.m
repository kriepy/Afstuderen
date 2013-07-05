% This script runs the clustered data
clear all
addpath ../../DATACorpus/forLDAbasic
load House254SL30Clusters30simple.mat

d=House.clus5D;
[a,b]=lda(d,3)