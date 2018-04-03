%% rfid_decoder script
% Important functions: getis.m, dec.m, frames.m, slice_signal.m
clear all;
close all;
clc;
dbstop if error
format compact
%path = 'C:\Users\Kevin\Documents\TU\Wireless_networking\RFID_sniffer-master\';
raw_data = 'data_new.dat';
%cd(path);
%addpath(genpath(path));
thres = 0.95*max(orig_sig);
[signal, norm] = getis(raw_data, thres); % get raw and normalized signal
fleng = 120000;
[frame,start] = frames(norm,fleng); %NB First two frame has a high chance of being corupt due to initialization
frame = frame(: , 3:end);
data = zeros(length(frame(1,:)),112);
for i=1:length(frame(1,:)-1)
   [bit,check,bitdata]=dec(frame(:,i)); %,hilo(i,:)
   bd(i,:)=bitdata';
   data(i,1:length(bit))=bit;
   checks(i)=check;
   delim(i,:) = bit(25:32);
   src(i,:) = bit(33:40);
   dst(i,:) =bit(41:48);
   msgtype(i,:) =bit(49:56);
   msgid(i,:) =bit(57:64);
   payload(i,:) =bit(65:96);
   crc(i,:) =bit(97:112);
   if check == 0 || length(bit)~=112
        numel = find(data(3,:)~=data(i,:));
        if numel(1)>0
            disp(['Invalid frame: ' num2str(i) ' extra zero at ' num2str(numel(1))]);
        else
            disp(['Invalid frame: ' num2str(i)]);
        end
   end
end

%%
% minimal bit length
figure; subplot(6,1,1)
histogram(bd(1:end,1))
title('min length 0 bit')
%ylim([min(bd(3:end,1))-2, max(bd(3:end,1))+2])
subplot(6,1,2)
histogram(bd(1:end,2))
title('max length 0 bit')
%ylim([min(bd(3:end,2))-2, max(bd(3:end,2))+2])
subplot(6,1,3)
histogram(bd(1:end,3))
title('min length 1 bit')
%ylim([min(bd(3:end,3))-2, max(bd(3:end,3))+2])
subplot(6,1,4)
histogram(bd(1:end,4))
title('max length 1 bit')
%ylim([min(bd(3:end,4))-2, max(bd(3:end,4))+2])
subplot(6,1,5)
histogram(bd(1:end,5))
title('Average bit length')
%ylim([min(bd(3:end,5))-2, max(bd(3:end,5))+2])
subplot(6,1,6)
histogram(bd(1:end,6))
title('Frame length')
%ylim([min(bd(3:end,6))-2, max(bd(3:end,6))+2])

%% frame conversion
figure;plot(signal); hold on; plot(start(1,3)-3,signal(start(1,3)),'r*'); xlim([start(1,3)-10000,start(1,3)+fleng])


%% TODO

% include automation threshold (low pass filter)
% pinpoint start and end of frame

% 


