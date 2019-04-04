clear all;
close all;
pic = imread('input1.jpg');
pic=im2double(pic);
k=6;
pic_size=size(pic);
imshow(pic);

[h,s,i] = rgb2hsi(pic);
i = i/3;
ch=cos(h);
sh=sin(h);

for i = 1:k,
    mean(:,i)=rand(3,1);
end

value = zeros(pic_size(1),pic_size(2)) + 4;
class = zeros(pic_size(1),pic_size(2));

while(1)
    check = false;
    for i=1:k,
        for j=1:pic_size(1),
            for a=1:pic_size(2),
                temp = 0;
                for l = 1:3,
                    temp = temp + ( pic(j,a,l) - mean(l,i) ) * ( pic(j,a,l) - mean(l,i) );
                end
                if(temp < value(j,a) )
                    class(j,a) = i;
                    value(j,a) = temp;
                    check = true;
                end
            end
        end
    end
    if(check == false)
        break;
    else
        for i=1:k,
            cla=(class==i);

            mean(1,i) = sum(sum( pic(:,:,1).*cla))/sum(sum(cla));
            mean(2,i) = sum(sum( pic(:,:,2).*cla))/sum(sum(cla));
            mean(3,i) = sum(sum( pic(:,:,3).*cla))/sum(sum(cla));
            
        end
    end
end
for i=1:k
    cla=(class==i);
    
    pic_temp = pic(:,:,1).*cla;
    pic_temp(:,:,2) = pic(:,:,2).*cla;
    pic_temp(:,:,3) = pic(:,:,3).*cla;


    figure();
    imshow(pic_temp);
end
