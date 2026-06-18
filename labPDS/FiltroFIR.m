%% Projeto de Filtros Digitais FIR - Laboratório de PDS
% Este script realiza as Tarefas Práticas 1.1, 1.2 e 1.3.
% Os resultados e gráficos são salvos automaticamente.

clear; clc; close all;

%% Tarefa Prática 1.1: Filtro Passa-Baixas FIR com Janela Hamming
fprintf('========================================================\n');
fprintf('Tarefa Prática 1.1: Filtro Passa-Baixas FIR (Hamming)\n');
fprintf('========================================================\n');

% Especificações
wp = 0.2*pi;
ws = 0.3*pi;
Rp = 0.25;
As = 50;

% Calculo dos parâmetros
Dw = ws - wp; % Banda de transição
wc = (wp + ws) / 2; % Frequencia de corte ideal
Df = Dw / (2*pi); % Banda de transição normalizada

% Para a janela de Hamming, a atenuação na banda de corte é 53 dB (satisfaz As >= 50 dB).
% A largura da transição teórica é Df = 3.3 / (N - 1) ou 3.3 / N (comprimento M = N + 1)
% Pela tabela: M = ceil(3.3 / Df) = ceil(3.3 / 0.05) = 66.
% Vamos escolher o comprimento M = 67 (ordem N = 66) para obter um filtro de ordem par (Tipo I).
N_hamming = 66; 
M_hamming = N_hamming + 1;

fprintf('Janela Selecionada: Hamming (Atenuacao típica = 53 dB, atende >= %d dB)\n', As);
fprintf('Comprimento do filtro M = %d (Ordem N = %d)\n', M_hamming, N_hamming);

% Resposta ao impulso ideal
hd = ideal_lp(wc, M_hamming);

% Janela de Hamming
w_hamming = hamming(M_hamming)';

% Resposta ao impulso truncada (filtro FIR)
h_hamming = hd .* w_hamming;

% Resposta em frequência usando freqz_m
[db_hamming, mag_hamming, pha_hamming, w] = freqz_m(h_hamming, 1);

% Plotagem
h_fig1 = figure('Visible', 'off');
subplot(2,1,1);
stem(0:N_hamming, h_hamming, 'filled', 'MarkerSize', 4);
grid on;
title('Resposta ao Impulso h[n] - Janela de Hamming');
xlabel('Amostras n');
ylabel('Amplitude');

subplot(2,1,2);
plot(w/pi, db_hamming, 'LineWidth', 1.5);
hold on;
plot([0, wp/pi, wp/pi], [-Rp, -Rp, -100], 'r--', 'LineWidth', 1);
plot([ws/pi, ws/pi, 1], [0, -As, -As], 'g--', 'LineWidth', 1);
grid on;
title('Resposta em Frequencia (Magnitude em dB) - Hamming');
xlabel('Frequencia Normalizada (\times\pi rad/amostra)');
ylabel('Ganho (dB)');
legend('Resposta do Filtro', 'Limite Passa-Banda (Rp)', 'Limite Rejeita-Banda (As)', 'Location', 'best');
ylim([-80 5]);
saveas(h_fig1, 'tarefa1_1.png');
close(h_fig1);
fprintf('Gráfico da Tarefa 1.1 salvo como tarefa1_1.png\n\n');


%% Tarefa Prática 1.2: Filtro Passa-Baixas FIR com Janela de Kaiser
fprintf('========================================================\n');
fprintf('Tarefa Prática 1.2: Filtro Passa-Baixas FIR (Kaiser)\n');
fprintf('========================================================\n');

% Especificações são as mesmas
% Calculando beta e a ordem M para a janela de Kaiser
% Usamos as equações teóricas de Kaiser:
delta_1 = (10^(Rp/20) - 1) / (10^(Rp/20) + 1);
delta_2 = 10^(-As/20);
delta = min(delta_1, delta_2);
A = -20 * log10(delta); % A será exatamente 50 dB

% Determinação de beta
if A > 50
    beta = 0.1102 * (A - 8.7);
elseif A >= 21
    beta = 0.5842 * (A - 21)^0.4 + 0.07886 * (A - 21);
else
    beta = 0.0;
end

% Determinação do comprimento M
M_kaiser_calc = (A - 8) / (2.285 * Dw);
M_kaiser = ceil(M_kaiser_calc);
% Para garantir filtro de ordem par (Tipo I), escolhemos M ímpar (ordem N par)
if mod(M_kaiser, 2) == 0
    M_kaiser = M_kaiser + 1;
end
N_kaiser = M_kaiser - 1;

fprintf('Calculo da Janela de Kaiser:\n');
fprintf('  delta_1 (passagem) = %f\n', delta_1);
fprintf('  delta_2 (corte) = %f\n', delta_2);
fprintf('  delta escolhido = %f\n', delta);
fprintf('  Atenuacao de projeto A = %.2f dB\n', A);
fprintf('  Parâmetro beta = %.4f\n', beta);
fprintf('  Comprimento calculado M = %.2f -> Escolhido M_kaiser = %d (Ordem N = %d)\n', ...
    M_kaiser_calc, M_kaiser, N_kaiser);

% Resposta ao impulso ideal
hd_k = ideal_lp(wc, M_kaiser);

% Janela de Kaiser
w_kaiser = kaiser(M_kaiser, beta)';

% Resposta ao impulso truncada
h_kaiser = hd_k .* w_kaiser;

% Resposta em frequência
[db_kaiser, mag_kaiser, pha_kaiser, w] = freqz_m(h_kaiser, 1);

% Comparacao gráfica
h_fig2 = figure('Visible', 'off');
subplot(2,1,1);
plot(w/pi, db_hamming, 'b--', 'LineWidth', 1.2);
hold on;
plot(w/pi, db_kaiser, 'r-', 'LineWidth', 1.5);
grid on;
title('Comparacao de Resposta em Frequencia (dB)');
xlabel('Frequencia Normalizada (\times\pi rad/amostra)');
ylabel('Ganho (dB)');
legend(sprintf('Hamming (N=%d)', N_hamming), sprintf('Kaiser (N=%d)', N_kaiser), 'Location', 'best');
ylim([-80 5]);

subplot(2,1,2);
stem(0:N_hamming, h_hamming, 'b--', 'Marker', 'o', 'MarkerSize', 3);
hold on;
stem(0:N_kaiser, h_kaiser, 'r-', 'Marker', 'x', 'MarkerSize', 4);
grid on;
title('Comparacao dos Coeficientes da Resposta ao Impulso');
xlabel('Amostras n');
ylabel('Amplitude');
legend(sprintf('Hamming (N=%d)', N_hamming), sprintf('Kaiser (N=%d)', N_kaiser), 'Location', 'best');
saveas(h_fig2, 'tarefa1_2.png');
close(h_fig2);
fprintf('Gráfico da Tarefa 1.2 salvo como tarefa1_2.png\n\n');


%% Tarefa Prática 1.3: Projeto Avançado Multibanda (Passa-Faixa)
fprintf('========================================================\n');
fprintf('Tarefa Prática 1.3: Projeto Avançado Multibanda\n');
fprintf('========================================================\n');

% Especificações
w1s = 0.2*pi;
w1p = 0.35*pi;
w2p = 0.65*pi;
w2s = 0.8*pi;
Rp = 1.0;
As = 60;

% Transition bands
Dw1 = w1p - w1s;
Dw2 = w2s - w2p;
Dw_min = min(Dw1, Dw2); % 0.15*pi
Df_min = Dw_min / (2*pi); % 0.075

% Para garantir As >= 60 dB com janela padrão, precisamos usar a janela Blackman (74 dB)
% Largura de transição teórica da Blackman: Df = 5.5 / N
% M_blackman = ceil(5.5 / Df_min) = ceil(5.5 / 0.075) = 74.
% Escolhemos M = 75 (ordem N = 74) para ser ímpar (ordem par).
N_blackman = 74;
M_blackman = N_blackman + 1;
w_blackman = blackman(M_blackman)';

% Frequencias de corte ideal (médias das frequências de transição)
wc1 = (w1s + w1p) / 2;
wc2 = (w2p + w2s) / 2;

% Resposta ao impulso ideal de um passa-faixa
% h_bp(n) = ideal_lp(wc2, M) - ideal_lp(wc1, M)
hd_bp = ideal_lp(wc2, M_blackman) - ideal_lp(wc1, M_blackman);
h_blackman = hd_bp .* w_blackman;
[db_blackman, mag_blackman, pha_blackman, w] = freqz_m(h_blackman, 1);

% Vamos projetar também com a janela de Kaiser para comparação!
delta_1 = (10^(Rp/20) - 1) / (10^(Rp/20) + 1);
delta_2 = 10^(-As/20);
delta = min(delta_1, delta_2); % delta = 0.001
A = -20 * log10(delta); % A = 60 dB

if A > 50
    beta_k3 = 0.1102 * (A - 8.7);
elseif A >= 21
    beta_k3 = 0.5842 * (A - 21)^0.4 + 0.07886 * (A - 21);
else
    beta_k3 = 0.0;
end

M_kaiser3_calc = (A - 8) / (2.285 * Dw_min);
M_kaiser3 = ceil(M_kaiser3_calc);
if mod(M_kaiser3, 2) == 0
    M_kaiser3 = M_kaiser3 + 1;
end
N_kaiser3 = M_kaiser3 - 1;

w_kaiser3 = kaiser(M_kaiser3, beta_k3)';
hd_bp_k = ideal_lp(wc2, M_kaiser3) - ideal_lp(wc1, M_kaiser3);
h_kaiser3 = hd_bp_k .* w_kaiser3;
[db_kaiser3, mag_kaiser3, pha_kaiser3, w] = freqz_m(h_kaiser3, 1);

fprintf('Projeto com Janela Blackman:\n');
fprintf('  Comprimento M = %d (Ordem N = %d)\n', M_blackman, N_blackman);
fprintf('Projeto com Janela de Kaiser:\n');
fprintf('  beta = %.4f\n', beta_k3);
fprintf('  Comprimento M = %d (Ordem N = %d)\n', M_kaiser3, N_kaiser3);

% Plotagem
h_fig3 = figure('Visible', 'off');
subplot(2,1,1);
plot(w/pi, db_blackman, 'b-', 'LineWidth', 1.2);
hold on;
plot(w/pi, db_kaiser3, 'r-', 'LineWidth', 1.5);
% Desenhar limites de especificação
plot([0, w1s/pi, w1s/pi], [-As, -As, 5], 'g--', 'LineWidth', 1);
plot([w1p/pi, w1p/pi, w2p/pi, w2p/pi], [-Rp, -Rp, -Rp, -Rp], 'r--', 'LineWidth', 1);
plot([w2s/pi, w2s/pi, 1], [5, -As, -As], 'g--', 'LineWidth', 1);
grid on;
title('Resposta em Frequencia (Magnitude em dB) - Passa-Faixa');
xlabel('Frequencia Normalizada (\times\pi rad/amostra)');
ylabel('Ganho (dB)');
legend(sprintf('Blackman (N=%d)', N_blackman), sprintf('Kaiser (N=%d)', N_kaiser3), 'Location', 'best');
ylim([-90 5]);

subplot(2,1,2);
stem(0:N_blackman, h_blackman, 'b', 'Marker', 'o', 'MarkerSize', 3);
hold on;
stem(0:N_kaiser3, h_kaiser3, 'r', 'Marker', 'x', 'MarkerSize', 4);
grid on;
title('Resposta ao Impulso de Projeto');
xlabel('Amostras n');
ylabel('Amplitude');
legend(sprintf('Blackman (N=%d)', N_blackman), sprintf('Kaiser (N=%d)', N_kaiser3), 'Location', 'best');
saveas(h_fig3, 'tarefa1_3.png');
close(h_fig3);
fprintf('Gráfico da Tarefa 1.3 salvo como tarefa1_3.png\n\n');

fprintf('========================================================\n');
fprintf('PROCESSAMENTO FIR COMPLETO COM SUCESSO!\n');
fprintf('========================================================\n');
