clear all;
close all;
pic = imread('input1.bmp');
pic_mo = imread('input1.bmp');
pic_ori = imread('input1_ori.bmp');
pic=im2double(pic);
%%model the gaussian filter in spatial domain
M = size(pic,1) ;
N = size(pic,2) ;
[X, Y] = meshgrid(1:N,1:M);
centerX = ceil(N/2);
centerY = ceil(M/2);
sigma=9;                    
gaussianNumerator = (X - centerX).^2 + (Y - centerY).^2;
H = exp(-gaussianNumerator./(2*sigma.^2)) ./ (2*pi*(sigma^2));
%%%%%%%%%
%%use wiener as the filter (wiener filter is defined as the function here)
pic2=wiener(pic,H,1,1000);

%%%deal with the outer ringing effect
m=50;
temp=pic;
temp(m:end+1-m,m:end+1-m,:)=pic2(m:end+1-m,m:end+1-m,:);

%%%calculate the psnr and output
temp=uint8(temp*255);
ps=psnr(temp(:,:,1),pic_ori(:,:,1))+psnr(temp(:,:,2),pic_ori(:,:,2))+psnr(temp(:,:,3),pic_ori(:,:,3));
ps2=psnr(pic_mo(:,:,1),pic_ori(:,:,1))+psnr(pic_mo(:,:,2),pic_ori(:,:,2))+psnr(pic_mo(:,:,3),pic_ori(:,:,3));
figure();
imshow(temp);
imwrite(temp,'output1.bmp');