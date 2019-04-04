clear all;
close all;
pic = imread('input2.bmp');
imshow(pic);
pic_mo = imread('input2.bmp');
pic_ori = imread('input2_ori.bmp');
pic=im2double(pic);

%%use fspecial to produce the motion filter
H=fspecial('motion',9,28);

%%use wiener filter
pic=wiener(pic,H,1,20);

temp=uint8(pic*255);

%%find the psnr
ps=psnr(temp(:,:,1),pic_ori(:,:,1))+psnr(temp(:,:,2),pic_ori(:,:,2))+psnr(temp(:,:,3),pic_ori(:,:,3));
ps2=psnr(pic_mo(:,:,1),pic_ori(:,:,1))+psnr(pic_mo(:,:,2),pic_ori(:,:,2))+psnr(pic_mo(:,:,3),pic_ori(:,:,3));

figure();
imshow(temp);
imwrite(temp,'output2.bmp');