%% TEST the pdfs and cdfs

x=[-pi:0.1:pi];

tic
y1=vonMisesCDF(x,0,6);
toc

tic
y2=normcdf(x,0,1/6);
toc
