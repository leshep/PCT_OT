
close all; clc; clear;
addpath(genpath('.'));

filename = {
    '\data\illum\input.png'... %1
    '\data\illum\reference_aligned.png'... %2
    '\data\gangnam2\input.png'... %3 
    '\data\gangnam2\reference_aligned.png'... %4 
    '\data\playground\input.png'...%5
    '\data\playground\reference_aligned.png'...%6
    '\data\mart\input.png'...%7
    '\data\mart\reference_aligned.png'...%8
    '\data\tonal4\input.png'...%9
    '\data\tonal4\reference_aligned.png'...%10
    '\data\tonal5\input.png'...%11
    '\data\tonal5\reference_aligned.png'...%12
    '\data\tonal3\input.png'...%13
    '\data\tonal3\reference_aligned.png'...%14
    '\data\tonal2\input.png'...%15
    '\data\tonal2\reference_aligned.png'...%16
    '\data\tonal1\input.png'...%17
    '\data\tonal1\reference_aligned.png'...%18
    '\data\gangnam1\input.png'...%19
    '\data\gangnam1\reference_aligned.png'...%20
    '\data\gangnam3\input.png'...%21
    '\data\gangnam3\reference_aligned.png'...%22
    '\data\flower1\input.png'...%23
    '\data\flower1\reference_aligned.png'...%24
    '\data\flower2\input.png'...%25
    '\data\flower2\reference_aligned.png'...%26
    '\data\building\input.png'...%27
    '\data\building\reference_aligned.png'...%28
    '\data\sculpture\input.png'...%29
    '\data\sculpture\reference_aligned.png'...%30
};

path = fullfile(pwd, 'results');
mkdir(path);

for j=1:2:30 
    
    selec = [j j+1];  

    %===== load images 
    for i=1:2
        im{i} = (uint8(imread([pwd, filename{selec(i)}])));
        h=figure; set(gcf,'color','w'); imshow(uint8(im{i}));
    end
    
    %===== match colors
    [out_img, out_img_CbCr, time] = PCT_OT(im);
    
    %===== store results       
    L= figure,set(gcf,'color','w');
    save(sprintf('%s\\%d_%d_CbCr_time.mat', path , selec(1), selec(2)), 'time'); 

    h=figure; set(gcf,'color','w'); imshow(out_img);
    set(h, 'Renderer', 'opengl');
    export_fig(h, sprintf('%s\\%d_%d_oTY_oTCbCr', path, selec(1), selec(2)),'-pdf','-q101', '-transparent');
    imwrite(out_img, sprintf('%s\\%d_%d_oTY_oTCbCr.png', path, selec(1), selec(2)));

end


