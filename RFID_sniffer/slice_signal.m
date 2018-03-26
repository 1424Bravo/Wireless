function [signal] =  slice_signal(datafile, start_signal, len_of_signal)
% FUNCTION: slice_signal taks three arguments: "datafile" the original
% signal, the starting point "start_signal" of the signal of interest, 
% and the length of  the signal of interest "len_fo_signal"

 f = fopen(datafile , 'rb');
 fseek(f, 4*start_signal, 'bof');
 signal = fread(f, len_of_signal, 'float'); % gnuradio complex data is represented as < float32, float32>

end