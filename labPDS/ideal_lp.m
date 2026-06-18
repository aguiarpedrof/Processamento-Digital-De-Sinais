function hd = ideal_lp(wc, M)
    % hd = ideal_lp(wc, M)
    % Compute the ideal impulse response of a lowpass filter
    % wc: cutoff frequency in radians
    % M: filter length (number of taps)
    
    alpha = (M - 1)/2;
    n = [0:(M-1)];
    m = n - alpha + eps; % Avoid division by zero
    hd = sin(wc*m)./(pi*m);
end
