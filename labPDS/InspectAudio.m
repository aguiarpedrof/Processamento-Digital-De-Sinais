info = audioinfo('fugee.wav');
fprintf('Sample Rate: %d Hz\n', info.SampleRate);
fprintf('Num Channels: %d\n', info.NumChannels);
fprintf('Duration: %.2f seconds\n', info.Duration);
fprintf('Total Samples: %d\n', info.TotalSamples);
