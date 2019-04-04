clear all;
clc;
close all;
pic=imread('input1.bmp');

for i=1:3,
    [N,edges]= histcounts(pic(:,:,i),256);
    for a=2:256,
        N(a)=N(a-1)+N(a);
    end
    min=find(N>0);
    pic(:,:,i)=uint8((N(pic(:,:,i)+1)-N(min(1)))*255.0/(800*1200-N(min(1))));
end

imshow(pic)
imwrite(pic,'wb.bmp'); 