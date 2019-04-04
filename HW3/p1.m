clear all;
clc;
close all;
pic = imread('input1.bmp');     %read the file

pic=im2double(pic);                 %change to double

pic=pic.^(0.5);                         %use the function to change the distribute
%h = fspecial('gaussian',3,0.5);     %gaussian filter with size 3 and variance 0.5
[x y]=meshgrid(1:3,1:3);
temp=(x-2).*(x-2)+(y-2).*(y-2);
h=exp(-temp / (2*0.5*0.5) );
h=h/sum(sum(h));

pic1=conv2(pic(:,:,1),h,'same');
pic1(:,:,2)=conv2(pic(:,:,2),h,'same');
pic1(:,:,3)=conv2(pic(:,:,3),h,'same');
imshow(pic1);
imwrite(pic1,'output1.bmp');