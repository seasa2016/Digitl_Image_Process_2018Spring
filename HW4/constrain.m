function  [output] = constrain(pic,ref,a,b),
    sizeI=size(pic);
    sizeI=sizeI(1:2);
    %%model p and fft
    p=[0 -1 0 ; -1 4 -1 ; 0 -1 0];
    H = psf2otf(ref, sizeI);
    P = psf2otf(ref, sizeI);
    clear ref;
    
    I(:,:,1) = fft2(pic(:,:,1),sizeI(1),sizeI(2));
    I(:,:,2) = fft2(pic(:,:,2),sizeI(1),sizeI(2));
    I(:,:,3) = fft2(pic(:,:,3),sizeI(1),sizeI(2));
    clear pic;
    
    %formula of constrain
    temp=(conj(H) .* H * b + a*P) ;
    %%avoid overflow
    temp = max(temp, sqrt(eps));
 
    I(:,:,1) = I(:,:,1) .* conj(H)*b ./ temp ;
    I(:,:,2) = I(:,:,2) .* conj(H)*b ./ temp ;
    I(:,:,3) = I(:,:,3) .* conj(H)*b ./ temp ;
    clear H;

    %ifft
    output=real(ifft2(I(:,:,1)));
    output(:,:,2)=real(ifft2(I(:,:,2)));
    output(:,:,3)=real(ifft2(I(:,:,3)));
    clear I;
end