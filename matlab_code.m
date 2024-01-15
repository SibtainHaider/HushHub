% Load the audio file and create an audioplayer object
[f, fs] = audioread('voice.wav');
pOrig = audioplayer(f, fs);

% Determine the total number of samples in the audio file
N = size(f, 1);

% Plot the original audio signal
figure;
subplot(4, 1, 1);
plot(1:N, f);
title('Original Audio Signal');
xlabel('Sample');
ylabel('Amplitude');

% Compute the frequency spectrum of the original signal
df = fs / N;
w = (-(N/2):(N/2)-1) * df;
y = fft(f, N) / N; % For normalizing, but not needed for our analysis
y2 = fftshift(y);

% Plot the frequency spectrum of the original signal
subplot(4, 1, 2);
plot(w, abs(y2));
title('Original Audio Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Filter design parameters
n = 21; % Filter order
beginFreq = 800; % Start frequency of the bandpass filter
endFreq = 12000; % End frequency of the bandpass filter

% Design a custom bandpass filter
[b, a] = my_bandpass_filter(n, beginFreq, endFreq, fs);

% Apply the bandpass filter to the original signal
fOut = filter(b, 1, f);

% Create an audioplayer object for the filtered signal
pFiltered = audioplayer(fOut, fs);

% Plot the filtered audio signal
subplot(4, 1, 3);
plot(1:N, fOut);
title('Filtered Audio Signal');
xlabel('Sample');
ylabel('Amplitude');

% Play the original signal
pOrig.play;

% Compute the frequency spectrum of the filtered signal
yFiltered = fft(fOut, N) / N;
yFiltered2 = fftshift(yFiltered);

% Plot the frequency spectrum of the filtered signal
subplot(4, 1, 4);
plot(w, abs(yFiltered2));
title('Filtered Audio Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Save the filtered output as a WAV file (replace if exists)
outputFilename = 'filtered_output.wav';
audiowrite(outputFilename, fOut, fs);

% Pause for 10 seconds
pause(10);

% Play the filtered signal
pFiltered.play;

% Function for custom bandpass filter
function [b, a] = my_bandpass_filter(order, beginFreq, endFreq, fs)
    % Design a bandpass filter using a windowed sinc function
    f1 = beginFreq / fs;
    f2 = endFreq / fs;
    midFreq = (f1 + f2) / 2;
    
    % Create a time vector for the filter coefficients
    t = (-order/2 : order/2) / fs;
    
    % Rectangular window (you can replace this with another window function)
    window_func = ones(1, order + 1);
    
    % Windowed sinc function
    sinc_func = sin(2 * pi * midFreq * t) ./ (pi * t);
    
    % Apply the window to the sinc function
    bandpass_filter = sinc_func .* window_func;
    
    % Normalize the filter to have unity gain at DC
    bandpass_filter = bandpass_filter / sum(bandpass_filter);
    
    b = bandpass_filter;
    a = 1;
end
