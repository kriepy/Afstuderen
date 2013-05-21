% This script runs the clustered data
clear all
addpath C:\Users\Kristin\UVA\Afstuderen\Afstuderen\Matlab\Data\DATACorpus\forLDAbasic
load House254SL30Clusters30simple.mat

d=House.clus5D;
[a,b]=lda(d,3)