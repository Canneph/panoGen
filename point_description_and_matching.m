function point_description_and_matching(img1_file, img2_file, fast_threshold, harris_threshold, match_prefix)
    I1 = imread(img1_file);
    I2 = imread(img2_file);
    
    % convert imgs to grayscale if need
    if size(I1,3) == 3
        I1_gray = rgb2gray(I1);
    else
        I1_gray = I1;
    end
    if size(I2,3) == 3
        I2_gray = rgb2gray(I2);
    else
        I2_gray = I2;
    end
    
    % detect fast and fastr keypoints in both imgs
    [~, ~, keypoints_fast1, keypoints_fastr1] = my_fastr_detector(img1_file, 'temp1.png', fast_threshold, harris_threshold);
    [~, ~, keypoints_fast2, keypoints_fastr2] = my_fastr_detector(img2_file, 'temp2.png', fast_threshold, harris_threshold);
    
    % use surf descriptor to compute features at keypoints
    [features_fast1, validPoints_fast1] = extractFeatures(I1_gray, keypoints_fast1, 'Method', 'SURF');
    [features_fast2, validPoints_fast2] = extractFeatures(I2_gray, keypoints_fast2, 'Method', 'SURF');
    
    [features_fastr1, validPoints_fastr1] = extractFeatures(I1_gray, keypoints_fastr1, 'Method', 'SURF');
    [features_fastr2, validPoints_fastr2] = extractFeatures(I2_gray, keypoints_fastr2, 'Method', 'SURF');
    
    % match features between two imgs using their descriptors
    indexPairs_fast = matchFeatures(features_fast1, features_fast2);
    indexPairs_fastr = matchFeatures(features_fastr1, features_fastr2);
    
    % retrieve matched points
    matchedPoints_fast1 = validPoints_fast1(indexPairs_fast(:,1));
    matchedPoints_fast2 = validPoints_fast2(indexPairs_fast(:,2));
    
    matchedPoints_fastr1 = validPoints_fastr1(indexPairs_fastr(:,1));
    matchedPoints_fastr2 = validPoints_fastr2(indexPairs_fastr(:,2));
    
    % visualize and save fast and fastr matches
    h1 = figure;
    showMatchedFeatures(I1, I2, matchedPoints_fast1, matchedPoints_fast2, 'montage');
    fastMatchFileName = [match_prefix, '-fastMatch.png'];
    saveas(h1, fastMatchFileName);
    close(h1);

    h2 = figure;
    showMatchedFeatures(I1, I2, matchedPoints_fastr1, matchedPoints_fastr2, 'montage');
    fastRMatchFileName = [match_prefix, '-fastRMatch.png'];
    saveas(h2, fastRMatchFileName);
    close(h2);
end