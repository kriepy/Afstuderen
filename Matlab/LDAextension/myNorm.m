function y=myNorm(x,mu,sigma)

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
    y=1;
    return
end

% this is the prob of the gaussian
y = normcdf(x+0.5,mu,sigma)- normcdf(x-0.5,mu,sigma);
%y = normcdf(x,mu,sigma);

%this is the density value of the funtion
% translate x to the standard normal distribution
% z=(x-mu)./sigma;
%y = exp(-0.5 * ((x - mu)./sigma).^2) ./ (sqrt(2*pi) .* sigma);

%% if the estimated probability is zero, return a very small number
[i,j]=find(y<0.00000001);
if length(i)
    for k=1:length(i)
        y(i(k),j(k))=0.00000001;
    end
end

% % % translate x to the standard normal distribution
% % z=(x-mu)./sigma;
% % 
% % 
% % try
% %     y = exp(-0.5 * ((z - mu)./sigma).^2) ./ (sqrt(2*pi) .* sigma);
% % catch
% %     error(message('stats:normpdf:InputSizeMismatch'));
% % end
% % 
% % %% if the estimated probability is zero, return a very small number
% % [i,j]=find(y<0.000000000001);
% % if length(i)
% %     for k=1:length(i)
% %         y(i(k),j(k))=0.000000000001;
% %     end
% % end