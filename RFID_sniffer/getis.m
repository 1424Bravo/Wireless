function [signal normsig] = getis(raw_data,thres)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   variables and data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

signal_start = 42e6;                                                     % [user-selectable] start of the chosen portion of the input data
signal_length = 25e6;                                                     % [user-selectable] length of the chosen portion of the input data

signal = slice_signal(raw_data, (signal_start),(signal_length));           % the sub_signal of interest

for i=1:numel(signal)
if signal(i)<thres
    temp(i)=0;
else 
    temp(i)=1;
end
end
normsig = temp;
end

