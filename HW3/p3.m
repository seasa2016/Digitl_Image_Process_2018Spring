clear all;
clc;
close all;
pic=imread('input3.bmp');
xx=size(pic);

%%%%%histogram equalizer
for i=1:3,
    [N,edges]= histcounts(pic(:,:,i),256);
    for a=2:256,
        N(a)=N(a-1)+N(a);
    end
    min=find(N>0);
    pic(:,:,i)=uint8((N(pic(:,:,i)+1)-N(min(1)))*255.0/(xx(1)*xx(2)-N(min(1))));
end

pic=im2double(pic);
%%%%gaussian filter
% h = fspecial('gaussian',5,0.7);
[x y]=meshgrid(1:5,1:5);
temp=(x-3).*(x-3)+(y-3).*(y-3);
h=exp(-temp / (2*0.7*0.7) );
h=h/sum(sum(h));


pic1=conv2(pic(:,:,1),h,'same');
pic1(:,:,2)=conv2(pic(:,:,2),h,'same');
pic1(:,:,3)=conv2(pic(:,:,3),h,'same');
% imshow(pic1);
imwrite(pic1,'output3.bmp');