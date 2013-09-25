function Y=myNormCombi(x,mu,sigma)
% this function combines the Poisson distribution with the vonMises/Gaus
% distribution in the last dimension. Which is the last row in the word x.
if nargin<1
    error(message('stats:normpdf:TooFewInputs'));
end
if nargin < 2
    mu = 0;
end
if nargin < 3
    sigma = 1;
end

% Return NaN for out of range parameters.
sigma(sigma <= 0) = NaN;
if isnan(sigma)
    Y=ones(size(x));
    return
end

% this is the prob of the poisson distribution
Y= PoisPDF(x(1:end-1,:),mu(1:end-1,:));

% this is the prob of the gaussian only applied to the last row of the data
y = normcdf(x(end,:)+0.5,mu(end,:),sigma)- normcdf(x(end,:)-0.5,mu(end,:),sigma);

%combine Pois and Gaus/Mises
Y=[Y;y];


%% if the estimated probability is zero, return a very small number
[i,j]=find(Y<0.0000000001);
if length(i)
    for k=1:length(i)
        Y(i(k),j(k))=0.0000000001;
    end
end
