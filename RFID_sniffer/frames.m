function [frame,start] = frames(norm,frame_length)
n = 1;i=1;
while i<numel(norm)
    if i-10000>10000 && (i+frame_length)<numel(norm)
    if norm(i) == 0
      frame(:,n)=norm(i-10000:i+frame_length-10000-1);
      start(:,n) = i;
      i = i + frame_length;
      n=n+1;
    end
    end
    i=i+1;
end
end
