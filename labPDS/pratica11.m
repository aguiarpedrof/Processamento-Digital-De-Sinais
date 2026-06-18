%% Tarefa 1.1 - Filtro FIR Passa-Baixa com Janela de Hamming
wp = 0.2; % Frequência de passagem normalizada (x pi)
ws = 0.3; % Frequência de corte normalizada (x pi)
As = 50;  % Atenuação em dB

% A frequência de corte ideal para o fir1 é o ponto médio da banda de transição
wc = (wp + ws) / 2; 
delta_w = ws - wp;

% Regra de bolso para ordem N com janela Hamming: N ~= 3.3 / delta_w
N_hamming = ceil(3.3 / delta_w); 
% Se a ordem for ímpar, o filtro passa-alta/rejeita-banda pode ter problemas, 
% mas para passa-baixa está ok. Vamos garantir uma ordem par para ter simetria perfeita.
if mod(N_hamming, 2) ~= 0, N_hamming = N_hamming + 1; end

% Projeto do filtro
janela = hamming(N_hamming + 1);
b_hamming = fir1(N_hamming, wc, 'low', janela);

% Plotagem usando a função freqz_m pedida no roteiro
figure;
[db, mag, pha, w] = freqz_m(b_hamming, 1);
plot(w/pi, db);
title('Tarefa 1.1: Resposta em Frequência (Hamming)');
xlabel('Frequência Normalizada (\times \pi rad/amostra)');
ylabel('Magnitude (dB)');
grid on;

% Plotagem da resposta ao impulso
figure;
stem(0:N_hamming, b_hamming, 'filled');
title('Tarefa 1.1: Resposta ao Impulso');
xlabel('Amostras (n)'); ylabel('Amplitude');