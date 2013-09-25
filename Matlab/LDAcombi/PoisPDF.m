function y=PoisPDF(x,lambda)
% this function calculates a the prob for the given x of the poisson
% distribution. I need to compare it with the poisspdf and see if my
% implementation is faster.

y = lambda.^x.*exp(-lambda)./gamma(x+1);