function y=myNormPoi(x,mu)

if nargin<1
    error(message('stats:poisspdf:TooFewInputs'));
end


y = PoisPDF(x,mu);

%% if the estimated probability is zero, return a very small number
[i,j]=find(y<0.000000001);
if length(i)
    for k=1:length(i)
        y(i(k),j(k))=0.000000001;
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