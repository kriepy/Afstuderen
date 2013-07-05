function x = mnormalize(m,d)

if nargin < 2
  d = 1;
end
v = sum(m,d);
if d == 1
  x = m * diag(1 ./ v);
elseif d == 2
  x = diag(1 ./ v') * m;
else
  error('mnormalize: dimension must be 1 or 2.');
end
