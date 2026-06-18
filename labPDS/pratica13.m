%% Tarefa 1.3 - Projeto Avancado Multibanda (Filtro Passa-Faixa)
% Especificacoes normalizadas (x pi)
w1s = 0.2;  % Frequencia de corte inferior
w1p = 0.35; % Frequencia de passagem inferior
w2p = 0.65; % Frequencia de passagem superior
w2s = 0.8;  % Frequencia de corte superior

% 1. Calculo das frequencias de corte (pontos medios)
wc1 = (w1s + w1p) / 2;
wc2 = (w2p + w2s) / 2;
Wn_multi = [wc1 wc2]; % O fir1 entende que 2 valores indicam um passa-faixa

% 2. Calculo da largura de transicao
delta_w = min((w1p - w1s), (w2s - w2p)); % Ambas sao 0.15

% 3. Escolha da janela e Ordem: Blackman para As = 60dB
N_multi = ceil(5.5 / delta_w); 
if mod(N_multi, 2) ~= 0 
    N_multi = N_multi + 1; % Forcando ordem par
end

janela_blackman = blackman(N_multi + 1);

% 4. Projeto do filtro
b_multi = fir1(N_multi, Wn_multi, 'bandpass', janela_blackman);

% 5. Plotagem
figure;
[db_m, mag_m, pha_m, w_m] = freqz_m(b_multi, 1);

% Para visualizar a banda de passagem de forma mais clara, 
% vamos limitar o eixo Y.
plot(w_m/pi, db_m, 'LineWidth', 1.5);
axis([0 1 -100 10]); % Focando na janela de magnitude de -100dB a 10dB
title('Tarefa 1.3: Filtro Passa-Faixa Multibanda (Blackman)');
xlabel('Frequencia Normalizada (\times \pi rad/amostra)');
ylabel('Magnitude (dB)');
grid on;

% Linhas horizontais e verticais para verificar se atende as especificacoes
yline(-60, 'r--', 'As = -60 dB', 'LabelHorizontalAlignment', 'left');
xline(0.2, 'k:'); xline(0.35, 'g:'); xline(0.65, 'g:'); xline(0.8, 'k:');