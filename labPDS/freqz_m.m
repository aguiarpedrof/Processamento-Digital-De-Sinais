function [db, mag, pha, w] = freqz_m(b, a)
    % [db, mag, pha, w] = freqz_m(b, a)
    % Modified freqz function for digital filter design
    % b: numerator coefficients
    % a: denominator coefficients
    % db: magnitude response in dB
    % mag: absolute magnitude response
    % pha: phase response in radians
    % w: frequency vector (0 to pi)
    
    [H, w] = freqz(b, a, 1000, 'whole');
    H = (H(1:501))';
    w = (w(1:501))';
    mag = abs(H);
    db = 20*log10((mag + eps)/(max(mag)));
    pha = angle(H);
end
