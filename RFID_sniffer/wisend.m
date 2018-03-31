%% rfid_decoder script
% Important functions: getis.m, dec.m, frames.m, slice_signal.m
clear all;
close all;
clc;
dbstop if error
format compact
raw_data = 'data/raw_data/data_new.dat';
addpath(genpath(cd));
% Set variables
fs = 8e6; % Sample rate
fleng = 0.015*fs; 
[signal, norm, x] = getis(raw_data, fs);
[frame,start] = frames(norm,fleng); 
frame = frame(: , 3:end);
data = zeros(length(frame(1,:)),112);
for i=1:length(frame(1,:)-1)
   [bit,check,bitdata]=dec(frame(:,i));
   bd(i,:)=bitdata';
   data(i,1:length(bit))=bit;
   checks(i)=check;
   if check == 1
        delim(i,:) = bit(25:32);
        src(i,:) = bit(33:40);
        dst(i,:) =bit(41:48);
        msgtype(i,:) =bit(49:56);
        msgid(i,:) =bit(57:64);
        payload(i,:) =bit(65:96);
        crc(i,:) =bit(97:112);
   end
   if check == 0 || length(bit)~=112
        numel = find(data(3,:)~=data(i,:));
        if numel(1)>0
            disp(['Invalid frame: ' num2str(i) ' extra zero at ' num2str(numel(1))]);
        else
            disp(['Invalid frame: ' num2str(i)]);
        end
   end
end
%% minimal bit length
figure; subplot(3,2,1);histogram(bd(1:end,1));title('min length 0 bit')
subplot(3,2,2);histogram(bd(1:end,2));title('max length 0 bit');
subplot(3,2,3);histogram(bd(1:end,3));title('min length 1 bit')
subplot(3,2,4);histogram(bd(1:end,4));title('max length 1 bit')
subplot(3,2,5);histogram(bd(1:end,5));title('Average bit length')
subplot(3,2,6);histogram(bd(1:end,6));title('Frame length')
%% frame conversion
figure;subplot(2,2,1);plot(signal); hold on; plot(start(1,3),signal(start(1,3)),'r*'); hold on; plot(start(1,3)+bd(1:1,6),signal(start(1,3)+bd(1:1,6)),'r*');xlim([start(1,3)-10000,start(1,3)+fleng]);title('Original signal (one frame)')
subplot(2,2,2);plot(x); hold on; plot(start(1,3),x(start(1,3)),'r*'); hold on; plot(start(1,3)+bd(1:1,6),x(start(1,3)+bd(1:1,6)),'r*');xlim([start(1,3)-10000,start(1,3)+fleng]);ylim([0.04, 0.05]);title('Filtered signal')
subplot(2,2,3);plot(dnorm); hold on; plot(start(1,3),dnorm(start(1,3)),'r*'); hold on; plot(start(1,3)+bd(1:1,6),dnorm(start(1,3)+bd(1:1,6)),'r*');xlim([start(1,3)-10000,start(1,3)+fleng]);ylim([-1.1, 1.1]);title('Differential signal')
subplot(2,2,4);plot(norm); hold on; plot(start(1,3),norm(start(1,3)),'r*'); hold on; plot(start(1,3)+bd(1:1,6),norm(start(1,3)+bd(1:1,6)),'r*');xlim([start(1,3)-10000,start(1,3)+fleng]);ylim([1-max(norm)*1.1,1.1*max(norm)]);title('Normalized signal')
