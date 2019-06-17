function [out_img, out_img_CbCr, time]= PCT_OT(im)

org_im=im;
time={};
wp= 2.5; wc= 1;
setting=2; % 1 c, 2 cp

for i=1:2
    [y x]= find(im{i}(:,:,1)>-1);
    temp= [x y];    
    im_pos{i}= reshape(temp,[size(im{i},1) size(im{i},2) 2]);
    sz{i}= size(im_pos{i});
    im_pos{i}= reshape(im_pos{i}, prod(sz{i}(1:2)), 2);
    
    mm=min(im_pos{i});
    MM=max(im_pos{i});
   
    im_pos{i}=((im_pos{i}-repmat(mm,[prod(sz{i}(1:2)) 1]))./repmat(MM-mm,[prod(sz{i}(1:2)) 1])*255);
    im_pos{i}=reshape(im_pos{i},sz{i});   
end

for i=1:2
    YCbCr{i}= rgb2ycbcr(im{i}); 
    CbCr{i}= YCbCr{i}(:,:,2:3); 
    Y{i}= YCbCr{i}(:,:,1); 
       
    if setting==1 %c
       im{i} = double(CbCr{i}); 
       imY{i}= double(Y{i});                
    else if setting==2 % c p
            im{i}= cat(3, double(CbCr{i})*wc, double(im_pos{i})*wp); 
            imY{i}=cat(3, double(Y{i})*wc, double(im_pos{i})*wp);                         
         end
    end       
end
         
org_Ndim = size(im{1},3);
Ndim=org_Ndim;
blockSizeR=5;
blockSizeC=5;

[im_1, patches_indices_1]= overlapGrouping(setting, im{1}, blockSizeR , blockSizeC, org_Ndim, 0, im_pos{1});    
[im_2, ~]= overlapGrouping(setting, im{2}, blockSizeR , blockSizeC, org_Ndim, 0, im_pos{2});

org_Ydim=size(imY{1},3);
[imY_1, patches_indices_Y_1]= overlapGrouping(setting, imY{1}, blockSizeR , blockSizeC, org_Ydim, 0, im_pos{1});    
[imY_2, ~]= overlapGrouping(setting, imY{2}, blockSizeR , blockSizeC, size(imY{1},3), 0, im_pos{2});   

%========== generate projection axes
Niter=30; % note that number of iteration is changable and not a fixed number for every image example

im{1}=im_1';
im{2}=im_2';
Ndim = size(im{1},2);
R{1}=eye(Ndim);
for n=2:Niter
    R{n} = R{1}*orth(randn(Ndim));
end
%  save(sprintf('%s\\R_%dD.mat', dir, Ndim),'R'); 
%  load(sprintf('%s\\R_%dD.mat', dir, Ndim));
%  clear im_1 im_2 ;

imY{1}=imY_1';
imY{2}=imY_2'; 
NdimY = size(imY{1},2);   
RY{1}=eye(NdimY);
for n=2:Niter
    RY{n} = RY{1}*orth(randn(NdimY));
end
%  save(sprintf('%s\\RY_%dD.mat', dir, NdimY),'RY');
%  load(sprintf('%s\\RY_%dD.mat', dir, NdimY));
%  clear imY_1 imY_2; 


%==========================================================================
ct=1;   
[So_, t1] = pdf_transfer(im{1}', im{2}', R); 
time{ct}= t1/60;

[SoY_, t2] = pdf_transfer(imY{1}', imY{2}', RY); 
time{ct+1}= t2/60;

%==========================================================================
So= overlapGrouping(setting, So_, blockSizeR , blockSizeC, org_Ndim, 1, -1, patches_indices_1, size(org_im{1},1), size(org_im{1},2));
SoY= overlapGrouping(setting, SoY_, blockSizeR , blockSizeC, org_Ydim, 1, -1, patches_indices_Y_1, size(org_im{1},1), size(org_im{1},2));
%==========================================================================

out_img_pos_So= So(:,:,3:4);
So= So(:,:,1:2);

out_img_pos_SoY= SoY(:,:,2:3);
SoY=SoY(:,:,1);

% de-factoring
out_img_pos_So=out_img_pos_So/wp;
out_img_pos_SoY=out_img_pos_SoY/wp;
So=So/wc;
SoY=SoY/wc;


%de-normalize pos
im_pos{1}=reshape(im_pos{1},prod(sz{1}(1:2)),2);
im_pos{1}=im_pos{1}/255.*repmat(MM-mm,[prod(sz{1}(1:2)) 1])+repmat(mm,[prod(sz{1}(1:2)) 1]);
im_pos{1}=reshape(im_pos{1},sz{1});

out_img_pos_So=reshape(out_img_pos_So,prod(sz{1}(1:2)),2);
out_img_pos_So=out_img_pos_So/255.*repmat(MM-mm,[prod(sz{1}(1:2)) 1])+repmat(mm,[prod(sz{1}(1:2)) 1]);
out_img_pos_So=reshape(out_img_pos_So,sz{1});

out_img_pos_SoY=reshape(out_img_pos_SoY,prod(sz{1}(1:2)),2);
out_img_pos_SoY=out_img_pos_SoY/255.*repmat(MM-mm,[prod(sz{1}(1:2)) 1])+repmat(mm,[prod(sz{1}(1:2)) 1]);
out_img_pos_SoY=reshape(out_img_pos_SoY,sz{1});

%%%%%

out_img= ycbcr2rgb(cat(3, uint8(SoY), uint8(So)));
out_img_CbCr= ycbcr2rgb(cat(3, YCbCr{1}(:,:,1), uint8(So)));


