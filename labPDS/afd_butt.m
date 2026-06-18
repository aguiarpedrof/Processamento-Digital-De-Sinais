function [b,a] = afd_butt(Wp, Ws, Rp, As)
    N = ceil((log10((10^(Rp/10)-1)/(10^(As/10)-1)))/(2*log10(Wp/Ws)));
    fprintf('\n*** Ordem do Filtro Butterworth = %2.0f \n', N);
    OmegaC = Wp/((10^(Rp/10)-1)^(1/(2*N)));
    [b,a] = u_buttap(N, OmegaC);
end