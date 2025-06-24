% set fastr detector parameters
fastthreshold = 15; 
harristreshold = 150; 

% set ransac parameters for fastr
ransacconfidence = 99.9; 
ransacmaxtrials = 1000;

% define image sets with 4 images each for s3 and s4
s3 = {'S3-im1.png', 'S3-im2.png', 'S3-im3.png', 'S3-im4.png'};
s4 = {'S4-im1.png', 'S4-im2.png', 'S4-im3.png', 'S4-im4.png'};

% create panoramas using only fastr keypoints
panoramaS3 = createPanorama(s3, fastthreshold, harristreshold, ransacconfidence, ransacmaxtrials);
panoramaS4 = createPanorama(s4, fastthreshold, harristreshold, ransacconfidence, ransacmaxtrials);

% save large stitched panoramas
imwrite(panoramaS3, 'S3-largepanorama.png');
imwrite(panoramaS4, 'S4-largepanorama.png');

% display panoramas
figure, imshow(panoramaS3);
figure, imshow(panoramaS4);