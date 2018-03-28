%% rfid_decoder script
% Important functions: getis.m, dec.m, frames.m
clear all;
close all;
clc;
dbstop if error
format compact
path = 'C:\Users\Kevin\Documents\TU\Wireless_networking\RFID_sniffer-master\';
raw_data = 'data/raw_data/data_new.dat';
cd(path);
addpath(genpath(path));
thres = 0.045;%0.95*max(orig_sig);
[signal, norm] = getis(raw_data, thres); % get raw and normalized signal
[frame] = frames(norm); %NB First two frame has a high chance of being corupt due to initialization
data = zeros(length(frame(1,:)),114);
for i=3:length(frame(1,:))
   [bit,check]=dec(frame(:,i));
   length(bit)
   data(i,1:length(bit))=bit;
   checks(i)=check;
   delim(i,:) = bit(17:24);
   src(i,:) = bit(25:32);
   dst(i,:) =bit(33:40);
   msgtype(i,:) =bit(41:48);
   msgid(i,:) =bit(49:56);
   payload(i,:) =bit(57:88);
   crc(i,:) =bit(89:104);
   if check == 0 || length(bit)~=113
        numel = find(data(3,:)~=data(i,:));
        disp(['Invalid frame: ' num2str(i) ' extra zero at ' num2str(numel(1))]);
   end
end

