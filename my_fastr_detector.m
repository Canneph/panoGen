function [fast_time, fastr_time, keypoints_fast, keypoints_fastr] = my_fastr_detector(input_image, output_image, fast_threshold, harris_threshold)
    % read and preprocess img
    I = imread(input_image);
    if size(I, 3) == 3
       I_gray = rgb2gray(I);
    else
       I_gray = I;
    end
    
    % fast detection (timed)
    tic;
    corners_fast = fast_detector(I_gray, fast_threshold);
    fast_time = toc;
    [rows_fast, cols_fast] = find(corners_fast);
    % store FAST keypoints as cornerPoints
    keypoints_fast = cornerPoints([cols_fast, rows_fast]);
    
    % compute sobel gradients
    I_double = double(I_gray);
    [Ix, Iy] = imgradientxy(I_double);
    
    % compute harris measure for each feature
    k = 0.04; % harris detector parameter
    gaus = fspecial('gaussian', 5, 1);
    Sx2 = imfilter(Ix.^2, gaus);
    Sy2 = imfilter(Iy.^2, gaus);
    Sxy = imfilter(Ix.*Iy, gaus);
    
    % compute the Harris corner response over entire img
    Harris_response = Sx2 .* Sy2 - Sxy.^2 - k * (Sx2 + Sy2).^2;
    tic;
    % extract response values at the FAST feature locations
    R_vals = Harris_response(sub2ind(size(Harris_response), rows_fast, cols_fast));
    valid_idx = find(R_vals >= harris_threshold);
    fastr_time = toc;
    fastR_rows = rows_fast(valid_idx);
    fastR_cols = cols_fast(valid_idx);
    
    % store FASTR keypoints as cornerPoints
    keypoints_fastr = cornerPoints([fastR_cols, fastR_rows]);
    
    % overlay FASTR points on img
    if size(I,3) == 1
       I_rgb = repmat(I, [1 1 3]);
    else
       I_rgb = I;
    end
    for i = 1:length(fastR_rows)
       I_rgb(fastR_rows(i), fastR_cols(i), :) = [255, 0, 0];
    end
    imwrite(I_rgb, output_image);
end