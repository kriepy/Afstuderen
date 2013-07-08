%% Compares two functions
x=20*rand(10,8);
lambda=20*rand(10,8);


tic
PoisPDF(x,lambda);
toc


tic
poisspdf(x,lambda);
toc