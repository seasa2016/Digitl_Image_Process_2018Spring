clear all;
close all;
pic = imread('input1.bmp');
pic_mo = imread('input1.bmp');
pic_ori = imread('input1_ori.bmp');
pic=im2double(pic);

%%model the gaussian filter
M = size(pic,1) ;
N = size(pic,2) ;
[X, Y] = meshgrid(1:N,1:M);
centerX = ceil(N/2);
centerY = ceil(M/2);
sigma=9;
gaussianNumerator = (X - centerX).^2 + (Y - centerY).^2;
H = exp(-gaussianNumerator./(2*sigma.^2)) ./ (2*pi*(sigma^2));

ps_temp=0;
%  for i=1:50,
%%use constrain least square as the filter
pic2=constrain(pic,H,1,10);

m=1;
temp=pic;
temp(m:end+1-m,m:end+1-m,:)=pic2(m:end+1-m,m:end+1-m,:);

temp=uint8(temp*255);
%find psnr
ps=psnr(temp(:,:,1),pic_ori(:,:,1))+psnr(temp(:,:,2),pic_ori(:,:,2))+psnr(temp(:,:,3),pic_ori(:,:,3));
%     if(ps_temp<ps),
%         i_temp=i;
%         ps_temp=ps;
%     end
% end

ps2=psnr(pic_mo(:,:,1),pic_ori(:,:,1))+psnr(pic_mo(:,:,2),pic_ori(:,:,2))+psnr(pic_mo(:,:,3),pic_ori(:,:,3));
figure();
imshow(temp);
imwrite(temp,'output1.bmp');