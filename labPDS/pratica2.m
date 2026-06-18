%% Parte 2 - Projeto de Filtros IIR via Prototipos Analogicos

%% Tarefa 2.1 - Prototipo Butterworth Analogico
Wp = 0.2 * pi; % Frequencia de passagem em rad/s
Ws = 0.3 * pi; % Frequencia de rejeicao em rad/s
Rp = 1;        % Ripple na banda de passagem em dB
As = 15;       % Atenuacao na banda de rejeicao em dB

% Projeto do filtro Butterworth
[b_butt, a_butt] = afd_butt(Wp, Ws, Rp, As);

% A tarefa pede para determinar a equacao do sistema. 
% Os vetores b e a contem os coeficientes do numerador e denominador de H(s).
disp('--- TAREFA 2.1: BUTTERWORTH ---');
disp('Coeficientes do Numerador (b):');
disp(b_butt);
disp('Coeficientes do Denominador (a):');
disp(a_butt);

% Plotagem da resposta em frequencia analogica
figure;
[db_b, mag_b, pha_b, w_b] = freqs_m(b_butt, a_butt, 0.5*pi);
plot(w_b/pi, db_b, 'LineWidth', 1.5);
title('Tarefa 2.1: Resposta em Frequencia - Butterworth Analogico');
xlabel('Frequencia (\times \pi rad/s)');
ylabel('Magnitude (dB)');

grid on;


%% Tarefa 2.2 - Prototipo Chebyshev Tipo I Analogico
% Projeto do filtro Chebyshev Tipo I usando as mesmas especificacoes
% OBS: verifique se o seu arquivo se chama afd_chbl.m ou afd_chb1.m e ajuste abaixo se necessario.
[b_cheb, a_cheb] = afd_chbl(Wp, Ws, Rp, As); 

disp('--- TAREFA 2.2: CHEBYSHEV ---');
disp('Coeficientes do Numerador (b):');
disp(b_cheb);
disp('Coeficientes do Denominador (a):');
disp(a_cheb);

% Plotagem da resposta em frequencia
figure;
[db_c, mag_c, pha_c, w_c] = freqs_m(b_cheb, a_cheb, 0.5*pi);
plot(w_c/pi, db_c, 'LineWidth', 1.5);
title('Tarefa 2.2: Resposta em Frequencia - Chebyshev Tipo I Analogico');
xlabel('Frequencia (\times \pi rad/s)');
ylabel('Magnitude (dB)');

grid on;