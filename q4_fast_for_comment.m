% NOTE: for FAST RANSAC parameter testing

% set fast detector parameter  
fastThreshold = 20;  

% set ransac parameters for fast
ransacConfidence = 99.9;  
ransacMaxTrials = 500;

% define image sets (each set has two images)
S1 = {'S1-im1.png', 'S1-im2.png'};  
S2 = {'S2-im1.png', 'S2-im2.png'};  
S3 = {'S3-im1.png', 'S3-im2.png'};  
S4 = {'S4-im1.png', 'S4-im2.png'};  

% create panoramas using fast keypoints
panoramaS1 = commentCreatePanorama(S1, fastThreshold, ransacConfidence, ransacMaxTrials);  
panoramaS2 = commentCreatePanorama(S2, fastThreshold, ransacConfidence, ransacMaxTrials);  
panoramaS3 = commentCreatePanorama(S3, fastThreshold, ransacConfidence, ransacMaxTrials);  
panoramaS4 = commentCreatePanorama(S4, fastThreshold, ransacConfidence, ransacMaxTrials);  

% save the stitched panoramas  
imwrite(panoramaS1, 'CS1-panorama.png');  
imwrite(panoramaS2, 'CS2-panorama.png');  
imwrite(panoramaS3, 'CS3-panorama.png');  
imwrite(panoramaS4, 'CS4-panorama.png');  

% show the panoramas (optional)
figure, imshow(panoramaS1);  
figure, imshow(panoramaS2);  
figure, imshow(panoramaS3);  
figure, imshow(panoramaS4);
