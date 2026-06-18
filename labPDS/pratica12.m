%% Tarefa 1.2 - Filtro FIR com Janela de Kaiser
% Especificacoes do roteiro
wp = 0.2;  % Frequencia de passagem normalizada (x pi)
ws = 0.3;  % Frequencia de rejeicao normalizada (x pi)
Rp = 0.25; % Ripple na banda de passagem em dB
As = 50;   % Atenuacao na banda de rejeicao em dB

% Para a funcao kaiserord, precisamos dos desvios lineares (nao em dB)
% Convertendo de dB para desvio linear (ripple):
dev_p = (10^(Rp/20)-1)/(10^(Rp/20)+1);
dev_s = 10^(-As/20);
devs = [dev_p dev_s];

% Frequencias de transicao e amplitudes desejadas (1 na passagem, 0 na rejeicao)
freqs = [wp ws]; 
amps = [1 0]; 

% A funcao kaiserord calcula a ordem (N), a frequencia de corte (Wn) 
% e o parametro beta ideais para a janela
[N_kaiser, Wn_kaiser, beta, ftype] = kaiserord(freqs, amps, devs);

% Forcando ordem par para garantir simetria perfeita
if mod(N_kaiser, 2) ~= 0
    N_kaiser = N_kaiser + 1; 
end

% Projeto do filtro usando a janela de Kaiser
janela_kaiser = kaiser(N_kaiser + 1, beta);
b_kaiser = fir1(N_kaiser, Wn_kaiser, ftype, janela_kaiser);

% Plotagem da resposta em frequencia
figure;
[db_k, mag_k, pha_k, w_k] = freqz_m(b_kaiser, 1);
plot(w_k/pi, db_k);
title('Tarefa 1.2: Resposta em Frequencia (Janela de Kaiser)');
xlabel('Frequencia Normalizada (\times \pi rad/amostra)'); 
ylabel('Magnitude (dB)');
grid on;

% Comparando as ordens no Command Window
fprintf('\n--- Comparacao de Ordens ---\n');
fprintf('Ordem com Hamming (Tarefa 1.1): 34\n');
fprintf('Ordem com Kaiser (Tarefa 1.2): %d\n', N_kaiser);
