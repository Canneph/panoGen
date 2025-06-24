function corner_points = my_fast_detector(input_image, output_image, threshold)
    I = imread(input_image);
    
    % if img coloured, convert to grayscale
    if size(I, 3) == 3
        I_gray = rgb2gray(I);
    else
        I_gray = I;
    end
    
    % detect corners using fast_detector
    corners = fast_detector(I_gray, threshold);
    
    % get the row and column indices of the detected corners
    [rows, cols] = find(corners);
    
    % create cornerPoints object
    corner_points = cornerPoints([cols, rows]);
    
    % if img is grayscale, convert it to rgb
    if size(I, 3) == 1
        I_rgb = repmat(I, [1, 1, 3]);
    else
        I_rgb = I;
    end
    
    % overlay red dots at each corner position
    for i = 1:length(rows)
        % set the pixel at (row, col) to red [255, 0, 0]
        I_rgb(rows(i), cols(i), :) = [255, 0, 0];
    end
    
    % save new img with corner overlay
    imwrite(I_rgb, output_image);
end
