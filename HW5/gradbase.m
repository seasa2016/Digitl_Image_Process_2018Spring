clear all;
close all;

pic_ori = imread('input1.jpg');
pic_double = im2double(pic_ori);
pic=rgb2gray(pic_ori);
pic=im2double(pic);

gau = fspecial('gaussian',19,1.2);
pic=imfilter(pic,gau);

threshold=0.2;

imshow(pic);

masky=[ 2,1,0;
        1,0,-1;
        0,-1,-2];
    
maskx=[ 0,-1,-2;
        1,0,-1;
        2,1,0]

gra_pic_y = imfilter(pic,masky);
gra_pic_x = imfilter(pic,maskx);

gra = gra_pic_x.*gra_pic_x + gra_pic_y.*gra_pic_y;

boundary = (gra > threshold);
boundary(1:4,:)=0;
boundary(:,1:4)=0;
boundary(end-3:end,:)=0;
boundary(:,end-3:end)=0;
for i=1:size(gra,1),
    for j=1:size(gra,2),
        if(boundary(i,j)),
            pic_ori(i,j,1)=255;
            pic_ori(i,j,2)=0;
            pic_ori(i,j,3)=0;
        end
    end
end

figure();
imshow(pic_ori);
imwrite(pic_ori,'Output1.jpg');