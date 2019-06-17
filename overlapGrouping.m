function [img,  patches_indices]= overlapGrouping(setting, rgbImage, blockSizeR , blockSizeC, nb_channels, op, relv_pos, patches_indices, orgRz, orgCz)

if op==0 
    
          
        [M N ~]= size(rgbImage);
        im_indices= reshape(1:M*N,[M,N]);
        patches_indices = im2col(im_indices, [blockSizeR, blockSizeC], 'sliding');

        for i=1: nb_channels
            patches_vals(:,:,i) = im2col(rgbImage(:,:,i), [blockSizeR, blockSizeC], 'sliding');  
        end
        
        %============================  relev pos ======================================
% %         sz=size(patches_vals);
% %          px=relv_pos(:,:,1);
% %         py=relv_pos(:,:,2);
% %         px=px(:);
% %         py=py(:);
% %         px=repmat(px,[1 size(patches_vals,2)]);
% %         py=repmat(py,[1 size(patches_vals,2)]);
% %         pxpy=cat(3, px, py);
% %         if setting==1
% %         elseif setting==2 % cp
% %             if sz(end)==4        
% %                 patches_vals=patches_vals(:,:,1:2);
% %                 patches_vals=cat(3, patches_vals, pxpy);        
% %             elseif sz(end)==3
% %                 patches_vals=patches_vals(:,:,1);
% %                 patches_vals=cat(3, patches_vals, pxpy);
% %             end
% %                     
% %         elseif setting==3 %cpg
% %             if sz(end)==6        
% %                 patches_vals_c=patches_vals(:,:,1:2);
% %                 patches_vals_g=patches_vals(:,:,5:6);
% %                 patches_vals=cat(3, patches_vals_c, pxpy, patches_vals_g);        
% %             elseif sz(end)==4
% %                 patches_vals_c=patches_vals(:,:,1);
% %                 patches_vals_g=patches_vals(:,:,4);
% %                 patches_vals=cat(3, patches_vals_c, pxpy, patches_vals_g);
% %             end
% %         end
% % 
% %         
% % 
% %         %==================================================================
        
        ca1 = mat2cell(patches_vals, blockSizeR*blockSizeC , [1 * ones(1, size(patches_vals,2))] , nb_channels);
        ca2 = cellfun(@ squeeze, ca1, 'UniformOutput', false);
        ca3 = cellfun(@transpose,ca2,'UniformOutput',false);
        ca4 = cellfun(@(x) reshape(x, blockSizeR*blockSizeC*nb_channels,[]), ca3, 'UniformOutput', false);
        img= cell2mat(ca4);

%         for c=1:size(patches_vals,2)
%             for i=1:nb_channels
%                 D0(i,:) = patches_vals(:,c,i)';
%             end
%             HD=reshape(D0, blockSizeR*blockSizeC*nb_channels,[])';% blockzr*blockzc*nbchannels
%             img(:,c)=HD; % 75Xpoints double
%         end  
    else
%         for c=1:size(rgbImage,2)
%             HD=rgbImage(:,c);
%             D0= reshape(HD',nb_channels,[]);
%             for i=1:nb_channels
%                 patches_vals(:,c,i) = D0(i,:)';  
%             end
%         end

        %reverse     
        rgbImage= mat2cell(rgbImage, size(rgbImage,1), [1 * ones(1, size(rgbImage,2))]);
        ca3_ = cellfun(@(x) reshape(x, nb_channels,[]), rgbImage, 'UniformOutput', false);
        ca2_ = cellfun(@transpose, ca3_, 'UniformOutput', false);
        ca1_ = cellfun(@(x) reshape(x, [blockSizeR*blockSizeC 1 nb_channels]),ca2_, 'UniformOutput', false);
        patches_vals= cell2mat(ca1_);

        for i=1: nb_channels
            vals= patches_vals(:,:,i);
            result= accumarray(patches_indices(:), vals(:))./accumarray(patches_indices(:), 1);
%              a1=patches_indices(13,:);
% % % % %             r1=result(a1);
% % % % %             a2=vals(13,:);
%              result(a1)=vals(13,:);
            img(:,:,i)= reshape(result, orgRz, orgCz);
        end
        
     
end
end
        

