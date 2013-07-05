function b = converged(u1,u2,threshhold)

% threshold
if (nargin < 3)
  threshhold = 1.0e-3;
end
% main
if (diff_vec(u1, u2) < threshhold)
  b = true;
else
  b = false;
end
