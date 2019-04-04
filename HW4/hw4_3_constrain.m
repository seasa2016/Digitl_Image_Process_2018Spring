clear all;
close all;
pic = imread('input3.bmp');
imshow(pic);
pic_mo = imread('input3.bmp');
pic_ori = imread('input3_ori.bmp');
pic=im2double(pic);
% ps_temp=0;
% for degree=1:10,
%      for i=3:20,
degree=1;
i=3;
%%model the gaussian filter
H=fspecial('gaussian',6*degree+1,degree);
%%use constrain filter
pic2=constrain(pic,H,1,i);

temp=uint8(pic2*255);

%%find psnr
ps=psnr(temp(:,:,1),pic_ori(:,:,1))+psnr(temp(:,:,2),pic_ori(:,:,2))+psnr(temp(:,:,3),pic_ori(:,:,3));
%         [degree ps];
%         if(ps_temp<ps),
%             degree_temp=degree; 
%             i_temp=i;
%             ps_temp=ps;
%         end
%      end
% end
ps2=psnr(pic_mo(:,:,1),pic_ori(:,:,1))+psnr(pic_mo(:,:,2),pic_ori(:,:,2))+psnr(pic_mo(:,:,3),pic_ori(:,:,3));

figure();
imshow(temp);
imwrite(temp,'output3.bmp');