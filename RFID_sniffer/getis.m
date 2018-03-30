function [signal, normsig, x] = getis(raw_data,fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   variables and data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

signal_start = 42e6;                                                     % [user-selectable] start of the chosen portion of the input data
signal_length = 25e6;                                                     % [user-selectable] length of the chosen portion of the input data

signal = slice_signal(raw_data, (signal_start),(signal_length));           % the sub_signal of interest
%% Filter
% fs = 8e6;
fc = 9000; % Cut off frequency
[b,a] = butter(6,fc/(fs/2)); % Butterworth filter of order 6
x = filter(b,a,signal); % Will be the filtered signal
thres=0.95*mean(x);
%% Normalize
for i=1:numel(signal)
if signal(i)<thres
    temp(i)=0;
else 
    temp(i)=1;
end
end
normsig = temp;

end