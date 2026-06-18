function [b,a] = afd_chbl(Wp, Ws, Rp, As)
    ep = sqrt(10^(Rp/10)-1);
    A = 10^(As/20);
    OmegaC = Wp;
    OmegaR = Ws/Wp;
    g = sqrt(A*A-1)/ep;
    N = ceil(log10(g+sqrt(g*g-1))/log10(OmegaR+sqrt(OmegaR*OmegaR-1)));
    fprintf('\n*** Ordem do Filtro Chebyshev-1 = %2.0f \n', N);
    [b,a] = u_chblap(N, Rp, OmegaC);
end