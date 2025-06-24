% NOTE: I followed the method and used code shown in [1] (approved by 
% Mohammad in discussion forum) to write the 'createPanorama' function

function panorama = createPanorama(imgFiles, fastThreshold, harrisThreshold, ransacConfidence, ransacMaxTrials)
numImages = numel(imgFiles);
    
    % set up transformation array with identity matrices
    tforms(numImages) = projective2d(eye(3));
    
    % store img sizes
    imageSize = zeros(numImages,2);
    xlim = zeros(numImages,2);
    ylim = zeros(numImages,2);
    
    % process first img
    I = imread(imgFiles{1});
    if size(I,3) == 3
        Igray = rgb2gray(I);
    else
        Igray = I;
    end
    imageSize(1,:) = size(Igray);
    
    % detect fastr keypoints and extract surf features
    [~, ~, ~, keypoints_fastr] = my_fastr_detector(imgFiles{1}, 'temp.png', fastThreshold, harrisThreshold);
    [features, validPoints] = extractFeatures(Igray, keypoints_fastr, 'Method', 'SURF');
    
    prevFeatures = features;
    prevValidPoints = validPoints;
    
    % loop through rest of imgs
    for n = 2:numImages
        I = imread(imgFiles{n});
        if size(I,3) == 3
            Igray = rgb2gray(I);
        else
            Igray = I;
        end
        imageSize(n,:) = size(Igray);
        
        % detect fastr keypoints and extract surf features for current img
        [~, ~, ~, keypoints_fastr] = my_fastr_detector(imgFiles{n}, 'temp.png', fastThreshold, harrisThreshold);
        [features, validPoints] = extractFeatures(Igray, keypoints_fastr, 'Method', 'SURF');
        
        % match features between current and previous img
        indexPairs = matchFeatures(features, prevFeatures, 'Unique', true, 'MatchThreshold', 5);
        matchedPoints = validPoints(indexPairs(:,1));
        matchedPointsPrev = prevValidPoints(indexPairs(:,2));
        
        % estimate transformation using RANSAC
        tform = estgeotform2d(matchedPoints, matchedPointsPrev, 'projective', ...
                    'Confidence', ransacConfidence, 'MaxNumTrials', ransacMaxTrials);
        
        % update transformation relative to the first img
        tforms(n) = projective2d(tform.T * tforms(n-1).T);
        
        % store features for next round
        prevFeatures = features;
        prevValidPoints = validPoints;
    end
    
    % compute output limits for each transformation
    for i = 1:numImages
        [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);
    end
    
    % find center img
    avgXLim = mean(xlim, 2);
    [~, idx] = sort(avgXLim);
    centerIdx = floor((numImages+1)/2);
    centerImageIdx = idx(centerIdx);
    
    % adjust transformations so centre img is the reference
    Tinv = invert(tforms(centerImageIdx));
    for i = 1:numImages
        tforms(i) = projective2d(Tinv.T * tforms(i).T);
    end
    
    % recompute output limits
    for i = 1:numImages
        [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);
    end
    
    % figure out the size of final panorama
    xMin = min([1; xlim(:)]);
    xMax = max([max(imageSize(:,2)); xlim(:)]);
    yMin = min([1; ylim(:)]);
    yMax = max([max(imageSize(:,1)); ylim(:)]);
    
    width  = round(xMax - xMin);
    height = round(yMax - yMin);
    
    % limit pano size
    maxWidth = 5000;  % set maximum width as needed
    maxHeight = 3000; % set maximum height as needed
    width = min(width, maxWidth);
    height = min(height, maxHeight);
    
    % set up empty panorama
    panorama = zeros([height width 3], 'like', I);
    
    % define coordinate space for pano
    xLimits = [xMin xMax];
    yLimits = [yMin yMax];
    panoramaView = imref2d([height width], xLimits, yLimits);
    
    % warp and blend each img into the panorama
    for i = 1:numImages
        I = imread(imgFiles{i});
        warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView);
        mask = imwarp(true(size(I,1), size(I,2)), tforms(i), 'OutputView', panoramaView);
        panorama = imblend(warpedImage, panorama, mask, 'ForegroundOpacity', 1);
    end

end