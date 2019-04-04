function [rgb] = hsi2rgb(h,s,i)
    r2= zeros(size(h, 1), size(h, 2));
    g2= zeros(size(h, 1), size(h, 2));
    b2= zeros(size(h, 1), size(h, 2));
    % RG sector (0 <= H < 2*pi/3).
    idx = find(  (h < 2*pi/3));
    b2(idx) =  (1 - s(idx))/3;
    r2(idx) =  (1 + s(idx) .* cos(h(idx))./cos(pi/3 - h(idx)))/3;
    g2(idx) = ( 1-  (r2(idx) + b2(idx)));
    % BG sector (2*pi/3 <= H < 4*pi/3).
    idx = find( (2*pi/3 <= h) & (h < 4*pi/3) );
    h(idx)=h(idx)- 2*pi/3;
    r2(idx) =  (1 - s(idx))/3;
    g2(idx) =  (1 + s(idx) .* cos(h(idx)) ./cos(pi/3 - h(idx)))/3;
    b2(idx) =  (1- (g2(idx) + r2(idx)));
    % BR sector.
    idx = find( (4*pi/3 <= h) );
    h(idx)=h(idx) - 4*pi/3;
    g2(idx) = (1 - s(idx))/3;
    b2(idx) = (1 + s(idx) .* cos(h(idx)) ./cos(pi/3 - h(idx)))/3;
    r2(idx) =  (1- (b2(idx) + g2(idx)));
    r2=r2.*i;
    g2=g2.*i;
    b2=b2.*i;
    rgb=cat(3, r2,g2 , b2);
    rgb = max(min(rgb, 1), 0);
end
