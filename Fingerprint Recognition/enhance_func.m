%part of this made by Vahid K. Alilou

function [ binim, mask] = enhance_func( img )
    addpath('./FExtraction/');
    [enhimg] =  fft_enhance_cubs(img, -1);
    blksze = 5;  thresh = 0.085;
    [normim, mask] = ridgesegment(enhimg, blksze, thresh);
    oimg2 = ridgeorient(normim, 1, 3, 3);
    [~, medfreq] = ridgefreq(normim, mask, oimg2, 32 , 5, 5, 15);
    binim = ridgefilter(normim, oimg2, medfreq.*mask, 0.5, 0.5, 1) > 0;
end

