%% Parte 3 - Aplicacao em Processamento de Audio

% --- Cenario 1: Filtro FIR Passa-Alta ---
% Ordem 34, Fc = 0.45 rad/amostra, janela de Chebyshev com 30 dB de atenuacao
N_pa = 34;
Wn_pa = 0.45;
janela_cheb = chebwin(N_pa + 1, 30);
b_pa = fir1(N_pa, Wn_pa, 'high', janela_cheb);

figure;
[db_pa, mag_pa, pha_pa, w_pa] = freqz_m(b_pa, 1);
plot(w_pa/pi, db_pa, 'LineWidth', 1.5);
title('Cenario 1: FIR Passa-Alta (Janela Chebyshev)');
xlabel('Frequencia (\times \pi rad/amostra)'); ylabel('Magnitude (dB)');
grid on;

% --- Cenario 2: Filtro FIR Passa-Faixa ---
% Ordem 48, Banda = [0.65, 0.75] * pi
N_pf = 48;
Wn_pf = [0.65 0.75];
b_pf = fir1(N_pf, Wn_pf, 'bandpass');

figure;
[db_pf, mag_pf, pha_pf, w_pf] = freqz_m(b_pf, 1);
plot(w_pf/pi, db_pf, 'LineWidth', 1.5);
title('Cenario 2: FIR Passa-Faixa');
xlabel('Frequencia (\times \pi rad/amostra)'); ylabel('Magnitude (dB)');
grid on;

% --- Analise de Sinal Corrompido (fugee.wav) ---
disp('--- Analisando o arquivo de audio ---');
try
    % Lendo o arquivo de audio
    [x, Fs] = audioread('fugee.wav');
    
    % Aplicando o filtro de Mediana (janela de 5 amostras)
    y_mediana = medfilt1(x, 5);
    
    % Plotagem dos espectros para comparacao (usando pwelch)
    figure;
    subplot(2,1,1);
    pwelch(x, [], [], [], Fs);
    title('Espectro do Sinal Original Corrompido (fugee.wav)');
    
    subplot(2,1,2);
    pwelch(y_mediana, [], [], [], Fs);
    title('Espectro apos Filtro de Mediana');
    
    disp('Processamento concluido! Graficos gerados com sucesso.');
    
    % Opcional: Se quiser ouvir o resultado, tire o '%' da linha abaixo
    % soundsc(y_mediana, Fs);
    
catch
    disp('ERRO: O arquivo "fugee.wav" nao foi encontrado!');
    disp('Por favor, coloque o arquivo de audio na pasta labPDS e rode novamente.');
end