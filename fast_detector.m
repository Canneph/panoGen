function corners = fast_detector(I, t)    
    % convert img to double for better precision
    I = double(I);
    
    % pad the img with a border of 3 pixels to handle the shifting
    I_padded = padarray(I, [3, 3], 'replicate');
    
    % get the 16 neighboring pixels using circshift
    % note: given instructor's hint, I found circshift from docs
    N1 = circshift(I_padded, [0,  3]);
    N2 = circshift(I_padded, [1,  3]);
    N3 = circshift(I_padded, [2,  2]);
    N4 = circshift(I_padded, [3,  1]);
    N5 = circshift(I_padded, [3,  0]);
    N6 = circshift(I_padded, [3, -1]);
    N7 = circshift(I_padded, [2, -2]);
    N8 = circshift(I_padded, [1, -3]);
    N9 = circshift(I_padded, [0, -3]);
    N10 = circshift(I_padded, [-1, -3]);
    N11 = circshift(I_padded, [-2, -2]);
    N12 = circshift(I_padded, [-3, -1]);
    N13 = circshift(I_padded, [-3,  0]);
    N14 = circshift(I_padded, [-3,  1]);
    N15 = circshift(I_padded, [-2,  2]);
    N16 = circshift(I_padded, [-1,  3]);
    
    % stack all neighbor imgs into a 3d array
    % note: i decided to use a 3d array because i wanted to compare each pixel with all 16 of its neighbors at once.  
    % if we kept them as separate 2d matrices, we’d have to write 16 separate comparisons, which is messy and tedious.  

    neighbors = cat(3, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15, N16);
    
    % replicate the original pixel intensities for comparison  
    I_rep = repmat(I_padded, [1, 1, 16]);
    
    % create masks for pixels that are much brighter or much darker than the candidate pixel
    brighter = neighbors > (I_rep + t);
    darker   = neighbors < (I_rep - t);
    
    % extend masks to check for contiguous pixels
    brighter_ext = cat(3, brighter, brighter(:, :, 1:11));
    darker_ext   = cat(3, darker, darker(:, :, 1:11));
    
    % use convolution with 1x1x12 kernel to see if there are 12 contiguous pixels  
    kernel = ones(1, 1, 12);
    sum_brighter = convn(brighter_ext, kernel, 'same');
    sum_darker   = convn(darker_ext, kernel, 'same');
    
    % store pixel if there is any contiguous group of 12 pixels that are all brighter / darker
    corners_padded = any(sum_brighter == 12, 3) | any(sum_darker == 12, 3);
    
    % remove the padded border to get the final corner mask in the original size
    corners = corners_padded(4:end-3, 4:end-3);
end