function [bit,check, bitdata] = dec(frame)
    part = frame; k_old=-1;
    data = diff(part);
    thresp=0.5; thresm=-0.5;
    rising = find(data>thresp)+1; %find edges
    falling = find(data<thresm);
    for i=1:(length(rising)-1)
        high(i) = falling(i+1) - rising(i);
    end
    for i=1:(length(falling)-1)
        low(i) = abs(rising(i) - falling(i));
    end
    low=low(2:end); % remove init error
    hilo = [high low];
    period = 2*min(abs(hilo));
    nump = numel(falling)+numel(rising)-1;
    start = falling(1);
    falris = [falling;rising];
    
 for i=1:nump
     if mean(part(start:start+period))<0.25 || mean(part(start:start+period)) > 0.75
         bit(i)=1;
     else
         bit(i) = 0;
     end
     start = start+period;
     [m,k] =min(abs(falris-start));
     if m>0
         start=falris(k);
     end
     if (start+period)>numel(part) || k==k_old || (m+start)>max(falris)
        break
     end
     k_old=k;
 end
 pre = rot90(de2bi(hex2dec('BBBB')))';
 check = isequal(pre,bit(1:length(pre)));

     hilo=sort(hilo);
     d = find((diff(hilo)>100)>0);
     bitdata(1) = 2*min(abs(hilo)); % min bit length 0
     bitdata(2) = 2*max(abs(hilo(1:d)));% max bit length 0
     bitdata(3) = min(abs(hilo(d+1:end)));% min bit length 1
     bitdata(4) = max(abs(hilo)); % max bit length 1
     bitdata(5) = mean([2*hilo(1:d) hilo(d+1:end)]);% Average bit length     
     bitdata(6) = rising(end)-falling(1);% Average bit length
end

