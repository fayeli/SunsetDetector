function [ fVec, block_h_end ] = extractFeature( img )
    
   
   L = img(:,:,1) + img(:,:,2) + img(:,:,3);
   S = img(:,:,1) - img(:,:,3);
   T = img(:,:,1) - img(:,:,2) - img(:,:,2) +img(:,:,3);
   
   h_img = size(img,1);
   w_img = size(img,2);
   
   h_block = floor(h_img/7);
   w_block = floor(w_img/7);
   
   h_remainder = h_img - h_block*7;
   w_remainder = w_img - w_block*7;
   
   fVec = zeros (294, 1);
   
   block_w_start = floor(w_remainder/2) + 1;
   block_w_end = block_w_start + w_block - 1;
   
   block_h_start = floor(h_remainder/2) + 1;
   block_h_end = block_h_start + h_block - 1;
   for b = 1:7
       fprintf('This is iteration %d\n', b);
       fprintf('block_w_start: %d\n', block_w_start);
       fprintf('block_w_end %d\n', block_w_end);
       fprintf('block_h_start: %d\n', block_h_start);
       fprintf('block_h_end %d\n', block_h_end);
       for i = block_w_start:block_w_end
           for j = block_h_start:block_h_end
           end
       end
       if (b ~= 7)
           block_w_start = block_w_end +1;
           block_w_end = block_w_start + w_block -1;
           block_h_start = block_h_end +1;
           block_h_end = block_h_start + h_block -1 ;
       end
   end
   fVec = 294;
   
end

