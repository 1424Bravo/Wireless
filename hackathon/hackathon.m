%% rfid_decoder script
clear all;
close all;
clc;

orig_sig = csvread('/home/nijhuis/Documents/Wireless/hackathon/hackathon_signal.dat');
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   variables and data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

signal_start = 42e6;                                                     % [user-selectable] start of the chosen portion of the input data
signal_length = 25e6;                                                     % [user-selectable] length of the chosen portion of the input data

samp_rate = 28e6;                                                          % sampling rate (must match the "samp_rate" variable from GNURadio sniffer file)
fs = samp_rate;
tari = 7.140e-6 - 2e-6;                                                    % RFID tag-dependent value (for WISP tari=7.140e-6). Two is subtracted because the power dip (end of symbol) is not considered
delimiter_time = 12.5e-6;                                                  % specified by the EPC C1G2 standard

% Data symbol delimiter sizes (EPC C1G2 specific)
Data_0_limits       = [ceil( 0.75*tari*samp_rate ) ceil(tari*samp_rate*1.1) ]; % Data-0 < 180 for 28MHz sample rate
Data_1_limits       = [ceil( tari * 1.3 *samp_rate) ceil(tari*1.8*samp_rate)];
delimiter_limits    = [(delimiter_time*samp_rate*0.8)  ceil(delimiter_time*samp_rate)];
RTCal_limits        = [tari*samp_rate *1.8 *(7.14/5.14) tari*samp_rate * 3 *(7.14/5.14)];
TRCal_limits        = [RTCal_limits(2)*1.1  RTCal_limits(2)*2 ];


%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   find the start of the signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
data = orig_sig.^-1

% beunstart:
begin = 1000;
ending = 1850;

thres = 1.82;

for i=1:(length(data))
if data(i)>thres
    temp(i) = 1;
else 
    temp(i) = 0;
end
end

frame = temp(begin:ending);

plot(frame)
%
n = 1;
x = 1;
while x < length(frame)
    countlow(n) = 0
    while frame(x) == 0 && x < length(frame)
        countlow(n) = countlow(n) + 1;
        x = x + 1;
    end
    counthigh(n) = 0;
    while frame(x) == 1 && x < length(frame)
        counthigh(n) = counthigh(n) + 1;
        x = x + 1;
    end
    n = n + 1;
end

% decoderen:
% als smalle piek: 0
% als brede piek:

% figure;plot(frame1)
% part = 4.1e5-2.8e5;
% for i=1:part
%     part1(i,1) = frame1(2.8e5+i);
% end
% part1 = frame1;
% figure;plot(part1)

%     rawdata=part1;
% %     rawdata=rawdata/max(rawdata); %normalize
%     data = diff(part1);
%     thresp=0.5;
%     thresm=-0.5;
%     rising = find(data>thresp);
%     falling = find(data<thresm)+1;
% 
%     low = rising - falling;
%     for i=1:(length(falling)-1)
%         high(i) = falling(i+1) - rising(i);
%     end
%     
% 
%     
%     period = round(min(low)*2);
%     
% %     if high(1)<mean(high)   % is first bit a 1 or 0
% %         bit(1) = 1;
% %     else 
% %         bit(1) = 0;
% %     end
%     
% %  nump = numel(falling)+numel(rising);
% %  start = rising(1);
% %  stop = 0;
% %  
% %  
% %  for i=1:nump   
% %      while stop==0
% %      if mean(part1(start:start+period))<0.25 || mean(part1(start:start+period)) > 1.75
% %          bit(i)=1;
% %      else
% %          bit(i) = 0;
% %      end
% %      if start+period > falling(length(falling))
% %          stop = 1
% %      else
% %         start = start+period;
% %      end
% %  end
% %  end
% % 
% %  bit = bit';
% %  
% %  
% % %  figure;plot(part1); hold on
% % %  for i=1:nump
% % %      line(rising(1)+i*period,0 1)
% %  end