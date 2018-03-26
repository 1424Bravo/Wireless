clear all;
close all;
clc;

% Basically, this script loops through the variable with the signal and
% searches 'high' occurences. If this happens, a packet has started. If the
% signal has been low for 'tlow'-part of a second áfter it has been high within the period, the frame is considered
% 'finished' in a transmission way. this value is stored in the variable
% 'array_end'. The signal can be read with intervals of the sample numbers
% of the frame_end array, to read one single frame per time. 


ARRAY = PUT_HERE_THE_SIGNAL_VARIABLE;
threshold = 0.6;    % Threshold signal level that indicates start of a frame: probably implement something with moving averages here, or just do it after normalizing.
samplerate = 100;   % samples per second
tlow = 0.5;         % Time before a packet has 'ended'. t in seconds


%%%% NO VARIABLES SHOULD BE MODIFIED BELOW HERE!!! %%%%%
while n < (length(ARRAY))
    hight = 0;          % checks if the frame has started
    lowc = 0;           % number of samples the signal has been below the threshold
    eop = 0;            % end of packet has been found, write signal to array
    p = 0;              % count the p't packet end.
	% loop through array, if signal is high a packet has started. when the signal is then low for a 'long' 
	% amount of time, the packet has ended.
    while eop == 0
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
			frame_end(p) = n; % dirty.
            p = p + 1;
			eop = 1;
            
		end
        n = n + 1;
    end
end
