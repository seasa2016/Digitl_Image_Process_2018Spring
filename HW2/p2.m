clear all;
clc;
close all;
pic=imread('input2.jpeg');

pic=im2double(pic);
r=pic(:,:,1);
g=pic(:,:,2);
b=pic(:,:,3);

h=acos((r-0.5*g-0.5*b)./sqrt((r-g).*(r-g)+(r-b).*(g-b) +0.0000000001));
h(b>g)=2*pi-h(b>g);

s = 1-3* min(min(r, g), b)./(r+g+b);
i = (r + g + b);

s=s*0.45;
idx1 = find(  (pi*(55)/180 <   h  & h <= pi*(70)/180     ));
h(idx1)=h(idx1)-pi*(30)/180;
s(idx1)=s(idx1)*0.9;
idx2 = find(  (pi*(70)/180 <   h  & h < pi*(140)/180     ));
h(idx2)=h(idx2)-pi*(45)/180;
s(idx2)=s(idx2)*0.9;

idx3 = find(  (pi*(140)/180 >   h));
s(idx3)=s(idx3)*0.9;
i(idx3)=i(idx3)*0.9;
%i(idx)=i(idx)*0;

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
r2(idx) = (1 - s(idx))/3;
g2(idx) = (1 + s(idx) .* cos(h(idx)) ./cos(pi/3 - h(idx)))/3;
b2(idx) =  (1- (b2(idx) + g2(idx)));

r2=r2.*i;
g2=g2.*i;
b2=b2.*i;

rgb=cat(3, r2,g2 , b2);
rgb = max(min(rgb, 1), 0);
rgb=uint8(rgb*255);
imshow(rgb)
imwrite(rgb,'trans.jpeg');