image = rgb2gray(im2double(imresize(imread("S1-im1.png"), 1)));
imshow(image)

sobel = [-1 0 1; -2 0 2; -1 0 1];
gaus = fspecial('gaussian', 5, 1);
dog = conv2(gaus, sobel);
ix = imfilter(image, dog);
iy = imfilter(image, dog);
ix2g = imfilter(ix .* ix, gaus);
iy2g = imfilter(iy .* iy, gaus);
ixiyg = imfilter(ix .* iy, gaus);
harcor = ix2g .* iy2g - ixiyg .* ixiyg - 0.05 * (ix2g + iy2g).^2;
imshow(harcor*50)