function [h,s,i] = rgb2hsi(pic),
    r=pic(:,:,1);
    g=pic(:,:,2);
    b=pic(:,:,3);

    h=acos((r-0.5*g-0.5*b)./sqrt((r-g).*(r-g)+(r-b).*(g-b) +0.00000001));
    h(b>g)=2*pi-h(b>g);
    s = 1-3* min(min(r, g), b)./(r+g+b+0.00000001);
    i = (r + g + b);
end