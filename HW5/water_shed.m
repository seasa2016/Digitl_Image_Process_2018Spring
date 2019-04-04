clear all;
close all;
pic = imread('input1.jpg');
pic = im2double(pic);
pic_ori = pic;

maskx=[ 2,1,0;1,0,-1;0,-1,-2];
masky=[ 0,-1,-2;1,0,-1;2,1,0];

gra_x = imfilter(pic,maskx);
gra_y = imfilter(pic,masky);



