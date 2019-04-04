function [l,a,b]=rgbtolab(pic),
    r=pic(:,:,1);
    g=pic(:,:,2);
    b=pic(:,:,3);
    x=zeros(size(r));
    y=zeros(size(g));
    z=zeros(size(b));
    
    for i=1:size(r,1)
        for j=1:size(r,2)
            x(i,j) = 0.412453*r(i,j)+0.357580*g(i,j)+0.180423*b(i,j);
            y(i,j) = 0.212671*r(i,j)+0.715160*g(i,j)+0.072169*b(i,j);
            z(i,j) = 0.02127*r(i,j)+0.119193*g(i,j)+0.950227*b(i,j);
        end
    end

    x=x/0.9515;
    z=z/1.0886;
    
    l = 903.3*y;
    idx = find(y > 0.008856);
    l(idx) = 116* (y(idx)).^(1/3)-16;
    
    X=x*7.787+16/116;
    Y=y*7.787+16/116;
    Z=z*7.787+16/116;
    
    idx = find(x > 0.008856);
    X(idx)=x(idx).^(1/3);
    idx = find(y > 0.008856);
    Y(idx)=y(idx).^(1/3);
    idx = find(z > 0.008856);
    Z(idx)=z(idx).^(1/3);
    
    
    a=500*(X-Y);
    b=500*(Y-Z);
end