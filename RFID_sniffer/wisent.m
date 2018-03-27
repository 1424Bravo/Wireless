%% rfid_decoder script
% Important functions: getis.m, dec.m, frames.m
clear all;
close all;
clc;
format compact
path = 'C:\Users\Kevin\Documents\TU\Wireless_networking\RFID_sniffer-master\';
raw_data = 'data/raw_data/data_new.dat';
cd(path);
addpath(genpath(path));
thres = 0.045;%0.95*max(orig_sig);
[signal, norm] = getis(raw_data, thres); % get raw and normalized signal
[frame] = frames(norm); %NB First two frame has a high chance of being corupt due to initialization
for i=3:length(frame(1,:))
   [bit,check]=dec(frame(:,i));
   data(i,:)=bit;
   checks(i)=check;
end