function [b,a] = u_buttap(N, Omegac)
    [z,p,k] = buttap(N);
    p = p * Omegac;
    k = k * Omegac^N;
    B = real(poly(z));
    b = k * B;
    a = real(poly(p));
end