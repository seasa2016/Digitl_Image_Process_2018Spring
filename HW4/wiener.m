function  [output] = wiener(pic,ref,a,b),
    sizeI=size(pic);
    sizeI=sizeI(1:2);
    %conpute the fft
    H = psf2otf(ref, sizeI);
    clear ref;
    
    I(:,:,1) = fft2(pic(:,:,1),sizeI(1),sizeI(2));
    I(:,:,2) = fft2(pic(:,:,2),sizeI(1),sizeI(2));
    I(:,:,3) = fft2(pic(:,:,3),sizeI(1),sizeI(2));
    clear pic;
    
    %%formula of wiener
    I(:,:,1) = I(:,:,1) .* conj(H)*b ./ (conj(H) .* H * b + a) ;
    I(:,:,2) = I(:,:,2) .* conj(H)*b ./ (conj(H) .* H * b + a) ;
    I(:,:,3) = I(:,:,3) .* conj(H)*b ./ (conj(H) .* H * b + a) ;
    clear H;
    
    %%avoid under zero
    I = max(I, sqrt(eps));
    
    %%ifft
    output=real(ifft2(I(:,:,1)));
    output(:,:,2)=real(ifft2(I(:,:,2)));
    output(:,:,3)=real(ifft2(I(:,:,3)));
    clear I;
end