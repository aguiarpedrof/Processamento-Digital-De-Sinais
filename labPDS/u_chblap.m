function [b,a] = u_chblap(N, Rp, Omegac)
    [z,p,k] = cheb1ap(N, Rp);
    p = p * Omegac;
    a = real(poly(p));
    aNu = a(N+1);
    [z2,p2,k2] = cheb1ap(N, Rp);
    a2 = real(poly(p2));
    aNn = a2(N+1);
    k = k * aNu / aNn;
    B = real(poly(z));
    b = k * B;
end