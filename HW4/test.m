close all;
clear all;
pic=imread('output1.bmp');
pic_ori = imread('input1_ori.bmp');

pic=im2double(pic);
pic_ori=im2double(pic_ori);

M = 27;
N = 27;
[X, Y] = meshgrid(1:N,1:M);
centerX = ceil(N/2);
centerY = ceil(M/2);
sigma=9;                    
gaussianNumerator = (X - centerX).^2 + (Y - centerY).^2;
H = exp(-gaussianNumerator./(2*sigma.^2)) ./ (2*pi*(sigma^2));

pic2=imfilter(pic,H,'conv');
temp=pic-pic2;
imshow(temp);

