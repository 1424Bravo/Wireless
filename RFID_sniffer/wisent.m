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
frame = frame(: , 3:end);
data = zeros(length(frame(1,:)),114);
for i=1:length(frame(1,:)-1)
   [bit,check,bitdata,hilo]=dec(frame(:,i));
   bd(i,:)=bitdata';
   data(i,1:length(bit))=bit;
   checks(i)=check;
   delim(i,:) = bit(17:24);
   src(i,:) = bit(25:32);
   dst(i,:) =bit(33:40);
   msgtype(i,:) =bit(41:48);
   msgid(i,:) =bit(49:56);
   payload(i,:) =bit(57:88);
   crc(i,:) =bit(89:104);
   if check == 0 || length(bit)~=112
        numel = find(data(3,:)~=data(i,:));
        if numel(1)~=0
            disp(['Invalid frame: ' num2str(i) ' extra zero at ' num2str(numel(1))]);
        else
            disp(['Invalid frame: ' num2str(i)]);
        end
   end
end

%%
% minimal bit length
figure; subplot(6,1,1)
plot(bd(1:end,1))
title('min length 0 bit')
ylim([min(bd(3:end,1))-2, max(bd(3:end,1))+2])
subplot(6,1,2)
plot(bd(1:end,2))
title('max length 0 bit')
ylim([min(bd(3:end,2))-2, max(bd(3:end,2))+2])
subplot(6,1,3)
plot(bd(1:end,3))
title('min length 1 bit')
ylim([min(bd(3:end,3))-2, max(bd(3:end,3))+2])
subplot(6,1,4)
plot(bd(1:end,4))
title('max length 1 bit')
ylim([min(bd(3:end,4))-2, max(bd(3:end,4))+2])
subplot(6,1,5)
plot(bd(1:end,5))
title('Average bit length')
ylim([min(bd(3:end,5))-2, max(bd(3:end,5))+2])
subplot(6,1,6)
plot(bd(1:end,6))
title('Frame length')
ylim([min(bd(3:end,6))-2, max(bd(3:end,6))+2])
