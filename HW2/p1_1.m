clear all;
clc;
close all;
pic=imread('input1.bmp');

[N,edges]= histcounts(pic(:,:,1),256);
for i=1:256,
    a=N(i)-sum(sum(pic(:,:,1)==(i-1)))
end