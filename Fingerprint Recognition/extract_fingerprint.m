function [ ret ] = extract_fingerprint( img)
addpath(genpath(pwd));
    block_size_c = 24;
    yt=1; xl=1; yb=size(img,2); xr=size(img,1);
    
    %Noise reduction
    
    for y=1:55
        if numel(find(img(y,:)<200)) < 8
           img(1:y,:) = 255;
           yt=y;
           break
        end
    end
    for y=225:size(img,1)
        if numel(find(img(y,:)<200)) < 3
           img(y:size(img,1),:) = 255;
           yb=y;
           break
        end
    end
    for x=200:size(img,2)
        if numel(find(img(:,x)<200)) < 1
           img(:,x:size(img,2)) = 255;
           xr=x;
           break
        end
    end
    for x=1:75
        if numel(find(img(:,x)<200)) < 1
           img(:,1:x) = 255;
           xl=x;
           break
        end	
    end
    
    %Elaborazioni dell'immagine (specifica applicazione per le impronte)
    %binim = immagine binaria
    %mask = maschera dell'impronta
    [ binim, mask] = enhance_func(img);
    
    %rifinitura della maschera..
    mask_t=mask;
    for y=19:size(mask,1)-block_size_c*2
        for x=block_size_c:size(mask,2)-block_size_c*2
          n_mask = 0;
          for yy=-1:1
              for xx=-1:1
                  y_t = y + yy *block_size_c; 
                  x_t = x + xx *block_size_c; 
                  if y_t > 0 && x_t > 0 && (y_t ~= y || x_t ~= x) && mask(y_t,x_t) == 0
                     n_mask = n_mask + 1;
                  end
              end
          end 
          if n_mask == 0
             continue 
          end
          if mask(y,x) == 0 || y > size(mask,1) - 20  ||  y < yt || y > yb || x < xl || x > xr
               mask_t(y,x) = 0;
               continue;
          end
          for i = y:y+1
            for j = x-9:x+9
              if i > 0 && j > 0 && i < size(mask,1) && j < size(mask,2) && mask(i,j) > 0
              else
                 mask_t(y,x)=0;
                 break
              end
            end
          end
        end
    end
    
    mask=mask_t;
    
    
    
    %operazioni morfologiche per perfezionare maschera
    
    b=strel('disk',5);
    out=imclose(mask,b);
    out=imclose(out,b);
    out=imclose(out,b);
    
    %immagine binaria in negativo (era analogo imcomplement)
    inv_binim = (binim == 0);
    %operazione di thinning (Infinite volte) sull'impronta
    thinned =  bwmorph(inv_binim, 'thin',Inf);
    
    %risultato = prodotto punto punto tra maschera (out) e thinned image
    %(thinned)
    ret=out.*thinned;
    
end