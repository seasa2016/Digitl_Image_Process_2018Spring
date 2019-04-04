clear all;
clc;
close all;

pic=imread('input4.bmp');       %read the file
pic=im2double(pic);

%use laplacian to find the edge
h = [[1 1 1],[1 -8 1],[1 1 1]]/4;

temp=conv2(pic(:,:,1),h,'same');
temp(:,:,2)=conv2(pic(:,:,2),h,'same');
temp(:,:,3)=conv2(pic(:,:,3),h,'same');
pic=pic-temp;
imshow(temp);
figure();

h = fspecial('gaussian',3,0.5);
[x y]=meshgrid(1:3,1:3);
temp=(x-2).*(x-2)+(y-2).*(y-2);
h=exp(-temp / (2*0.5*0.5) );
h=h/sum(sum(h));

pic2=pic;
pic2=conv2(pic(:,:,1),h,'same');
pic2(:,:,2)=conv2(pic(:,:,2),h,'same');
pic2(:,:,3)=conv2(pic(:,:,3),h,'same');

%%use hsi to that the graph more light
r=pic2(:,:,1);
g=pic2(:,:,2);
b=pic2(:,:,3);

h=acos((r-0.5*g-0.5*b)./sqrt((r-g).*(r-g)+(r-b).*(g-b) +0.00000001));
h(b>g)=2*pi-h(b>g);
s = 1-3* min(min(r, g), b)./(r+g+b+0.00000001);
i = (r + g + b);
%%%%%%%%%%%%%%%%%%%%%%%%%%
i=i*1.2;
%%%%%%%%%%%%%%%%%%
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
rgb=uint8(rgb*255);
% imshow(rgb);
imwrite(rgb,'output4.bmp');