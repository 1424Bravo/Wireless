clear, close all

% ET4394: Wireless Networking course.
% LoRa demodulation demonstration script. Created by Guillermo Ortas.

% RUN SECTION BY SECTION USING THE "Run and Advance" BUTTON

%% Import recorded LoRa signal
[in, fs] = audioread('SDRSharp_20180224_215814Z_869700000Hz_IQ.wav');
% Allocate in-phase and quadrature components and make sure it's a row vector
x = complex(in(:,2), in(:,1)).';
clear in
% Plot spectrogram and see the patterns of the captured frame
mySpectrogram(x, fs, 512, false);

%% LoRa parameters
% These are acquired by inspecting the spectrogram
BW = 125e3;
SF = 12;
symbols_per_frame = 40;
fc = 0.173e6; % center frequency of the recorded signal
symbol_time = 2^SF/BW;

%% Channelize and resample signal (DDC)
% Bring signal to baseband (observe spectrum doubling)
t = 0:1/fs:length(x)/fs-1/fs;
x = x.*cos(2*pi*fc*t);
mySpectrogram(x, fs, 512, false);
%% Filter the signal to preserve only the range [-BW/2, BW/2]
freqs = [0 BW/fs BW/fs*9/8 1];
damps = [1 1 0 0];
order = 100;
b = firpm(order,freqs,damps);
x = filter(b,1,x);
mySpectrogram(x, fs, 512, false);
%% Resampling: 
x = resample(x, BW, fs); % Output sampling frequency is BW (Nyquist)
fs = BW;
mySpectrogram(x, fs, 64, true);
clear t b damps freqs fc order

%% Chirp generation
% Generate a local complex up-chirp of the appropriate rate
f0 = -BW/2; f1 = BW/2;
t = 0:1/fs:symbol_time - 1/fs;
chirpI = chirp(t, f0, symbol_time, f1, 'linear', 90);
chirpQ = chirp(t, f0, symbol_time, f1, 'linear', 0);
upChirp = complex(chirpI, chirpQ);
clear chirpI chirpQ t f0 f1
mySpectrogram(upChirp, fs, 64, true);

%% Synchronize signal (crop it exactly at the start of the frame)
% Find the start of the signal by correlating it with the local up-chirp
[corr, lag] = xcorr(x, upChirp);
corrThresh = max(abs(corr))/10; % Value was tuned experimentally
cLag = find(abs(corr) > corrThresh, 1);
signalStartIndex = abs(lag(cLag));
signalEndIndex = round(signalStartIndex + symbols_per_frame*symbol_time*fs);
figure, plot(lag, abs(corr)), grid on, xlabel('Lag (samples)'), ylabel('Correlation')
% Crop signal in time
x = x(signalStartIndex:signalEndIndex);
clear lag corr corrThresh
mySpectrogram(x, fs, 64, true);

%% De-chirping
% Repeat upchirps to match the signal length
upChirp = repmat(upChirp,1,ceil(length(x)/length(upChirp)));
upChirp = upChirp(1:length(x));
% Multiply the signal with the complex conjugate of the local up-chirp
de_chirped = x.*conj(upChirp); % remove conj to demodulate downchirps
mySpectrogram(de_chirped, fs, 256, true);

%% Spectrogram conditioning
% Create a spectrogram 'grid' of symbols, Nfft must be 2^SF for this.
mySpectrogram(de_chirped, fs, 2^SF, true);
% Notice how power is split into adjacent symbols, having two strong
% components per symbol time. This ruins symbol identification.

%% Align data segment
% We earlier synced the start of the signal with the correlation function,
% but we now need to align the data part of the frame, which is misaligned
% because of the extra 0.25 symbol time of the SFD. We add this 0.25 now.
symbol_offset = 0.25;
x = x(symbol_offset*symbol_time*fs:end);
upChirp = upChirp(1:length(x));
de_chirped = x.*conj(upChirp);
s = mySpectrogram(de_chirped, fs, 2^SF, true);
% Check out how much cleaner this looks now.
% We have now shifted the preamble/training sequence 0.25*BW hertz to the
% right, but this is fine because we know the preamble is always zero and
% we can reference all other symbols to it.

%% Bit extraction
% Since we have computed the spectrogram in such a way that there is only
% one temporal sample per symbol and 2^SF samples per frequency, it's now a
% matter to find the strongest frequency bin per symbol time.
[~, symbols] = max(abs(s));
% We average the values of the first 8 symbols of the preamble (the last
% two are a special sync word) and we subtract the result
% from all other values in the frame, so eveything is lined up.
symbols = mod(symbols - round(mean(symbols(1:8))), 2^SF);
% Translation into base 2 to retrieve the raw bits that were sent.
bits =  dec2base(symbols, 2);

% You can now check the result in the 'symbols' or 'bits' vectors. The
% first 8 values should be zero and the next two are the special
% synchronization word. Then, there are the two (two and a quarter) SFD
% symbols (which are not properly demodulated because they used a
% down-chirp instead of up-chirp) and actual data starts at position 13.
% We would then take these results into the decoding stage and proceed to
% see what was sent.


function s = mySpectrogram(x, fs, NFFT, zero_freq)
BW = 125e3;
% Spectrogram computation and plotting
window_length = NFFT;
[s, f, t] = spectrogram(x, blackman(window_length), 0, NFFT, fs);
if zero_freq
    f = linspace(-BW/2, BW/2, length(f));
end
figure, surf(f/1000, t, 10*log10(abs(s.')),'EdgeColor','none')
axis xy; axis tight; colormap(jet); view(0,90);
ylabel('Time (s)');
xlabel('Frequency (kHz)');
end

