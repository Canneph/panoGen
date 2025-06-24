fast_threshold = 21;   
harris_threshold = 1e5;

my_fastr_detector('S1-im1.png', 'S1-fastR.png', fast_threshold, harris_threshold);
my_fastr_detector('S2-im1.png', 'S2-fastR.png', fast_threshold, harris_threshold);
