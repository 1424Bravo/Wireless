function [rest] = crc_check(px)
    gx = [1 1 0 0 0 0 0 0 0 0 0 0 0 1 0 1];
    pxr=[px zeros(1,length(gx)-1)];
    [c r]=deconv(pxr,gx);
    r=mod(abs(r),2);
    rest=r(length(px)+1:end);
end