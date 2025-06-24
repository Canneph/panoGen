% set fastr detector parameters  
fastThreshold = 20;  
harrisThreshold = 200;  

% set ransac parameters for fastr  
ransacConfidence = 99.9;  
ransacMaxTrials = 400;

% define image sets (each set has two images)  
S1 = {'S1-im1.png', 'S1-im2.png'};  
S2 = {'S2-im1.png', 'S2-im2.png'};  
S3 = {'S3-im1.png', 'S3-im2.png'};  
S4 = {'S4-im1.png', 'S4-im2.png'};  

% make panoramas using only fastr keypoints  
panoramaS1 = createPanorama(S1, fastThreshold, harrisThreshold, ransacConfidence, ransacMaxTrials);  
panoramaS2 = createPanorama(S2, fastThreshold, harrisThreshold, ransacConfidence, ransacMaxTrials);  
panoramaS3 = createPanorama(S3, fastThreshold, harrisThreshold, ransacConfidence, ransacMaxTrials);  
panoramaS4 = createPanorama(S4, fastThreshold, harrisThreshold, ransacConfidence, ransacMaxTrials);  

% save stitched panoramas  
imwrite(panoramaS1, 'S1-panorama.png');  
imwrite(panoramaS2, 'S2-panorama.png');  
imwrite(panoramaS3, 'S3-panorama.png');  
imwrite(panoramaS4, 'S4-panorama.png');  

% show panoramas  
figure, imshow(panoramaS1);  
figure, imshow(panoramaS2);  
figure, imshow(panoramaS3);  
figure, imshow(panoramaS4);