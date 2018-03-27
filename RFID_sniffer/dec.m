function [bit,check] = dec(frame)
    part = frame;
    data = diff(part);
    thresp=0.5;
    thresm=-0.5;
    rising = find(data>thresp)+1;
    falling = find(data<thresm);
    high = falling(1:numel(rising)) - rising;
   
    for i=1:(length(rising)-1)
        low(i) = rising(i+1) - falling(i);
    end
    low = low';
    
    period = ceil((min(abs(low))+min(abs(high)))/2);    

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
     if (start+period)>numel(part)
        break
     end
 end
 

 pre = rot90(de2bi(hex2dec('BBBB')))';
 check = isequal(pre,bit(1:length(pre)));
end

