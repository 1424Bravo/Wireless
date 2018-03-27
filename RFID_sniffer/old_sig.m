%% rfid_decoder script
clear all;
close all;
clc;
format compact
path = 'C:\Users\Kevin\Documents\TU\Wireless_networking\RFID_sniffer-master\';
% path = cd;
raw_data = 'data/raw_data/data.dat';
cd(path);
addpath(genpath(path));
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

signal = slice_signal(raw_data, (signal_start),(signal_length));           % the sub_signal of interest

%%
orig_sig = signal;

% Part Sjors

n = 1;
t = linspace(0,20*pi);
x = square(t);
% plot(t,x);

thres = 0.7;%0.95*max(orig_sig);
for i=1:numel(orig_sig)
if orig_sig(i)<thres
    temp(i)=0;
else 
    temp(i)=1;
end
end

ARRAY = temp';
threshold = 0.7;    % Threshold signal level that indicates start of a frame: probably implement something with moving averages here, or just do it after normalizing.
samplerate = samp_rate;   % samples per second
tlow = 0.0005;         % Time before a packet has 'ended'. t in seconds
frame_end = 0;

%%%% Determine frames %%%%%
while n < length(ARRAY)
    hight = 0;          % checks if the frame has started
    lowc = 0;           % number of samples the signal has been below the threshold
    eop = 0;            % end of packet has been found, write signal to array
    p = 1;              % count the p't packet end.
	% loop through array, if signal is high a packet has started. when the signal is then low for a 'long' 
	% amount of time, the packet has ended.
    while eop == 0 && n<length(ARRAY)
		% if signal is high: packet has started.
        
		if ARRAY(n) >= threshold
			hight = 1;
            lowc = 0;
        else
            lowc = lowc + 1;
        end
       
		if (hight == 1) && (lowc > (samplerate * tlow)) 
            % end of frame detected: signal has been high in the past and
            % has been low for a while.
			frame_end = [frame_end n]; % dirty.
            p = p + 1;
			eop = 1;
            
		end
        n = n + 1;
    end
end

%% Part Kevin

first = frame_end(2);
last = frame_end(3);
fleng = last-first;;
for i=1:fleng
    frame1(i,1) = temp(first+i);
end
    part1 = frame1;
    data = diff(part1);
    thresp=0.5;
    thresm=-0.5;
    rising = find(data>thresp)+1;
    falling = find(data<thresm)+1;
    high = falling - rising;
   
    for i=1:(length(rising)-1)
        low(i) = rising(i+1) - falling(i);
    end
    low = low';
    
 period = ceil((min(low)+min(high))/2);   
 nump = numel(falling)+numel(rising)-1;
 start = falling(1); 
 falris = [falling;rising];
 
 for i=1:nump
     if start+period<max(falris)
        i = nump;  
     if mean(part1(start:start+period))<0.25 || mean(part1(start:start+period)) > 0.75
         bit(i)=1;
     else
         bit(i) = 0;
     end
     start = start+period;
     [m,k] =min(abs(falris-start));
     if m>0
         start=falris(k);
     end
     end
 end






    
    
    