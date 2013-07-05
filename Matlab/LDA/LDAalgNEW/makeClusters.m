function d=makeClusters(House,HN,SL,c,V)
% The House data is loaded for all houses, but returned will only the data
% for the House with the number HN. All data will actually be saved, so
% that it is faster for other houses. SL is the length of the time slices
% given in minutes (default is 30). If c equals 'Coarse' the time is set
% into coarse grain (NoCoarse means no time is taken into account). V is
% the amount of clusters.