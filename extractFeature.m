function fVec = extractFeature( img )
    
   img_double = double(img);
   
   L = img_double(:,:,1) + img_double(:,:,2) + img_double(:,:,3);
   S = img_double(:,:,1) - img_double(:,:,3);
   T = img_double(:,:,1) - img_double(:,:,2) - img_double(:,:,2) + img_double(:,:,3);
   
   h_img = size(img_double,1);
   w_img = size(img_double,2);
   
   h_block = floor(h_img/7);
   w_block = floor(w_img/7);
   num_pixels = h_block * w_block;
   
   h_remainder = h_img - h_block*7;
   w_remainder = w_img - w_block*7;
   
   fVec = zeros (294, 1);
   
   block_h_start = floor(h_remainder/2) + 1;
   block_h_end = block_h_start + h_block - 1;
   
   for a = 1:7
       block_w_start = floor(w_remainder/2) + 1;
       block_w_end = block_w_start + w_block - 1;
       
       for b = 1:7
           L_sum = sum(sum(L(block_h_start:block_h_end, block_w_start:block_w_end)));
           S_sum = sum(sum(S(block_h_start:block_h_end, block_w_start:block_w_end)));
           T_sum = sum(sum(T(block_h_start:block_h_end, block_w_start:block_w_end)));

           L_mean = L_sum / num_pixels;
           S_mean = S_sum / num_pixels;
           T_mean = T_sum / num_pixels;

           L_block_vals = L(block_h_start:block_h_end, block_w_start:block_w_end);
           L_std_dev = std(L_block_vals(:));
           S_block_vals = S(block_h_start:block_h_end, block_w_start:block_w_end);
           S_std_dev = std(S_block_vals(:));
           T_block_vals = T(block_h_start:block_h_end, block_w_start:block_w_end);
           T_std_dev = std(T_block_vals(:));

           fVec((42 * (a - 1)) + b * 6 - 5, 1) = L_mean;
           fVec((42 * (a - 1)) + b * 6 - 4, 1) = L_std_dev;
           fVec((42 * (a - 1)) + b * 6 - 3, 1) = S_mean;
           fVec((42 * (a - 1)) + b * 6 - 2, 1) = S_std_dev;
           fVec((42 * (a - 1)) + b * 6 - 1, 1) = T_mean;
           fVec((42 * (a - 1)) + b * 6 - 0, 1) = T_std_dev;

           if (b ~= 7)
               block_w_start = block_w_end +1;
               block_w_end = block_w_start + w_block -1;
           end
       end
       if (a ~= 7)
           block_h_start = block_h_end +1;
           block_h_end = block_h_start + h_block -1 ;
       end
   end
   
end

