clear all;
close all;
pic = imread('input3.bmp');
imshow(pic);
pic_mo = imread('input3.bmp');
pic_ori = imread('input3_ori.bmp');
pic=im2double(pic);
ps_temp=0;
degree=4;
% for degree=4:4,
%     for i=1:8,
%%model the kernel
H=fspecial('gaussian',6*degree+1,degree);

%use wiener filter
pic2=wiener(pic,H,1,20);
%pic2=deconvwnr(pic,H,0.1);

temp=uint8(pic2*255);

%%find psnr
ps=psnr(temp(:,:,1),pic_ori(:,:,1))+psnr(temp(:,:,2),pic_ori(:,:,2))+psnr(temp(:,:,3),pic_ori(:,:,3));
%         if(ps_temp<ps),
%             degree_temp=degree; 
%             i_temp=i;
%             ps_temp=ps;
%         end
%     end
% end
ps2=psnr(pic_mo(:,:,1),pic_ori(:,:,1))+psnr(pic_mo(:,:,2),pic_ori(:,:,2))+psnr(pic_mo(:,:,3),pic_ori(:,:,3));

figure();
imshow(temp);
imwrite(temp,'output3.bmp');