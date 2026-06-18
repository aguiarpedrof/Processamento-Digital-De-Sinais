%% Processamento de Audio com Filtros FIR e Nao-Lineares
% Este script realiza a Parte 3 do laboratorio:
% 1. Carrega fugee.wav
% 2. Plota o espectro original
% 3. Aplica o filtro passa-alta Chebyshev (Cenario 1)
% 4. Aplica o filtro passa-faixa Hamming (Cenario 2)
% 5. Aplica o filtro nao-linear de mediana
% 6. Salva os espectros para analise

clear; clc; close all;

%% 1. Carregar o arquivo de audio
fprintf('========================================================\n');
fprintf('Carregando fugee.wav...\n');
fprintf('========================================================\n');
[x, Fs] = audioread('fugee.wav');
N_samples = length(x);
t = (0:N_samples-1)/Fs;

fprintf('Taxa de Amostragem Fs: %d Hz\n', Fs);
fprintf('Numero total de amostras: %d\n', N_samples);
fprintf('Duracao: %.2f segundos\n', N_samples/Fs);

%% 2. Analise de Sinal Corrompido (Espectro Original)
% Usamos a FFT para calcular o espectro de frequencias
N_fft = 4096;
X = fft(x, N_fft);
X_mag = abs(X(1:N_fft/2+1));
freq = (0:N_fft/2) * (Fs/2) / (N_fft/2);

% Plotar sinal no tempo e espectro de magnitude original
h_fig1 = figure('Visible', 'off');
subplot(2,1,1);
plot(t(1:min(length(t), 8000)), x(1:min(length(x), 8000)));
grid on;
title('Sinal de Audio no Dominio do Tempo (Primeiro 1 segundo)');
xlabel('Tempo (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(freq, 20*log10(X_mag + eps));
grid on;
title('Espectro de Frequencia do Sinal Original');
xlabel('Frequencia (Hz)');
ylabel('Magnitude (dB)');
saveas(h_fig1, 'audio_original.png');
close(h_fig1);
fprintf('Espectro original salvo como audio_original.png\n\n');


%% 3. Cenario 1: Filtro FIR Passa-Altas Chebyshev
fprintf('========================================================\n');
fprintf('Projetando Filtro FIR Passa-Altas Chebyshev (Cenario 1)\n');
fprintf('========================================================\n');
% Ordem: 34, Cutoff: 0.45*pi, Chebyshev window, 30 dB de atenuacao
N_hp = 34;
wc_hp = 0.45; % Frequencia de corte normalizada (0.45*pi rad/amostra)
% Chebyshev window para M = N_hp + 1 = 35, com 30 dB de atenuacao
win_cheb = chebwin(N_hp + 1, 30);
b_hp = fir1(N_hp, wc_hp, 'high', win_cheb);

% Filtrar o sinal
y_hp = filter(b_hp, 1, x);

% Salvar o audio filtrado para que o usuario possa ouvir
audiowrite('fugee_passa_alta.wav', y_hp, Fs);
fprintf('Audio filtrado (Passa-Alta) salvo como fugee_passa_alta.wav\n');


%% 4. Cenario 2: Filtro FIR Passa-Faixa
fprintf('========================================================\n');
fprintf('Projetando Filtro FIR Passa-Faixa (Cenario 2)\n');
fprintf('========================================================\n');
% Ordem: 48, Passband: 0.65*pi a 0.75*pi rad/amostra
N_bp = 48;
wc_bp = [0.65, 0.75]; % Frequencias de corte normalizadas
b_bp = fir1(N_bp, wc_bp, 'bandpass'); % Usa Hamming por padrao

% Filtrar o sinal
y_bp = filter(b_bp, 1, x);

% Salvar o audio filtrado
audiowrite('fugee_passa_faixa.wav', y_bp, Fs);
fprintf('Audio filtrado (Passa-Faixa) salvo como fugee_passa_faixa.wav\n');


%% 5. Filtragem Nao-Linear (Mediana)
fprintf('========================================================\n');
fprintf('Aplicando Filtro de Mediana\n');
fprintf('========================================================\n');
% Filtro de mediana de ordem 5
y_med = medfilt1(x, 5);

% Salvar o audio filtrado pela mediana
audiowrite('fugee_mediana.wav', y_med, Fs);
fprintf('Audio filtrado (Mediana) salvo como fugee_mediana.wav\n\n');


%% 6. Comparacao dos Espectros
fprintf('========================================================\n');
fprintf('Gerando comparacao dos espectros...\n');
fprintf('========================================================\n');

% Calcular espectros para os sinais filtrados
Y_hp = fft(y_hp, N_fft);
Y_hp_mag = abs(Y_hp(1:N_fft/2+1));

Y_bp = fft(y_bp, N_fft);
Y_bp_mag = abs(Y_bp(1:N_fft/2+1));

Y_med = fft(y_med, N_fft);
Y_med_mag = abs(Y_med(1:N_fft/2+1));

% Plotar comparativo
h_fig2 = figure('Visible', 'off');

subplot(2,2,1);
plot(freq, 20*log10(X_mag + eps));
grid on; title('Original');
xlabel('Frequencia (Hz)'); ylabel('Magnitude (dB)');
ylim([-80 40]);

subplot(2,2,2);
plot(freq, 20*log10(Y_hp_mag + eps), 'r');
grid on; title('FIR Passa-Alta (Chebyshev)');
xlabel('Frequencia (Hz)'); ylabel('Magnitude (dB)');
ylim([-80 40]);

subplot(2,2,3);
plot(freq, 20*log10(Y_bp_mag + eps), 'g');
grid on; title('FIR Passa-Faixa (Hamming)');
xlabel('Frequencia (Hz)'); ylabel('Magnitude (dB)');
ylim([-80 40]);

subplot(2,2,4);
plot(freq, 20*log10(Y_med_mag + eps), 'm');
grid on; title('Filtro de Mediana (Ordem 5)');
xlabel('Frequencia (Hz)'); ylabel('Magnitude (dB)');
ylim([-80 40]);

saveas(h_fig2, 'audio_comparacao_espectros.png');
close(h_fig2);
fprintf('Grafico de comparacao de espectros salvo como audio_comparacao_espectros.png\n');
fprintf('PROCESSAMENTO DE AUDIO CONCLUIDO!\n');
