function betas = accum_beta(betas,q,d)

betas = betas + d' * q;
