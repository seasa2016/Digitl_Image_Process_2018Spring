clear all;
close all;
pic = imread('input2.bmp');
imshow(pic);
pic_mo = imread('input2.bmp');
pic_ori = imread('input2_ori.bmp');
pic=im2double(pic);
ps_temp=0;

% for degree=130:130,
%     for len=2:2,
%         for i=97:97,

%%definition of motion
H=fspecial('motion',2,130);

%%use constrain filter
pic2=constrain(pic,H,1,97);

temp=uint8(pic2*255);
%%find psnr
ps=psnr(temp(:,:,1),pic_ori(:,:,1))+psnr(temp(:,:,2),pic_ori(:,:,2))+psnr(temp(:,:,3),pic_ori(:,:,3));
%             [degree len ps];
%             if(ps_temp<ps),
%                 degree_temp=degree; 
%                 i_temp=i;
%                 len_temp=len;
%                 ps_temp=ps;
%             end
%         end
%     end
% end
ps2=psnr(pic_mo(:,:,1),pic_ori(:,:,1))+psnr(pic_mo(:,:,2),pic_ori(:,:,2))+psnr(pic_mo(:,:,3),pic_ori(:,:,3));

figure();
imshow(temp);
imwrite(temp,'output2.bmp');