clear all;
close all;

% define fictive array
ARRAY = rand(10000,1);
n = 1;
p = 1;
samplerate = 200;
threshold = 0.95;
while n < (length(ARRAY))
	hight = 0;
    lowc = 0;
    	eop = 0;

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
       
		% signal has been high and low for a long while:
		if (hight == 1) && (lowc > samplerate/2)
			packetend(p) = n;
            p = p + 1;
			eop = 1;
            disp('end of packet found!')
		end
        n = n + 1;
    end
end
