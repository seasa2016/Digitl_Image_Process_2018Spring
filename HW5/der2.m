clear all;
close all;

pic_ori = imread('input1.jpg');
pic_double = im2double(pic_ori);
pic=rgb2gray(pic_ori);
pic=im2double(pic);
threshold=0;

gau = fspecial('gaussian', 19 , 1);
pic=imfilter(pic,gau);

pic_size=size(pic);

imshow(pic);

mask =[0,0,-1,0,0;
       0,-1,-2,-1,0;
       -1,-2,16,-2,-1;
       0,-1,-2,-1,0;
       0,0,-1,0,0];

gra_pic = imfilter(pic,mask);

for i=1:pic_size(1),
    for j=1:pic_size(2),
        if(gra_pic(i,j)>0.3),
            pic_ori(i,j,1)=255;
            pic_ori(i,j,2)=0;
            pic_ori(i,j,3)=0;
        end
    end
end


figure();
imshow(pic_ori);
imwrite(pic_ori,'Output1.jpg');