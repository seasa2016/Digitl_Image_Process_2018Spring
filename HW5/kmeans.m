clear all;
close all;

pic_ori = imread('input1.jpg');
pic = pic_ori;
pic=im2double(pic);
k=5;
pic_size=size(pic);
imshow(pic);

gau = fspecial('gaussian',19,2);
pic=imfilter(pic,gau);

for i = 1:k,
    mean(:,i)=rand(3,1);
end

value = zeros(pic_size(1),pic_size(2)) + 3;
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
                if((temp - value(j,a)) < -1e-05 )
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

way=[-1,0;0,-1;1,0;0,1];
for i=1:pic_size(1),
    for j=1:pic_size(2),
        check=[1,1,1,1];
        if(i==1),
            check(1)=0;
        end
        if(j==1),
            check(2)=0;
        end
        if(i==pic_size(1)),
            check(3)=0;
        end
        if(j==pic_size(2)),
            check(4)=0;
        end
        for k=1:4,
            if(check(k)==1)
                if(class(i+way(k,1),j+way(k,2)) ~= class(i,j)),
                    pic_ori(i,j,1)=255;
                    pic_ori(i,j,2)=0;
                    pic_ori(i,j,3)=0;
                end
            end
        end
    end
end
imshow(pic_ori);
imwrite(pic_ori,'Output1.jpg');