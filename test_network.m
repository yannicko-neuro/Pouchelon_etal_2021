testImage = imread('3-NLP5#3-S1-Stitching-19-Mirror-23-Image Export-03_c1+2c2.tif');
C = semanticseg(testImage,net);



testImage = imread('13-Experiment-478(3)-Stitching-07-Image Export-19_c1+2c3.tif');
windowSize = 1024;
myFilterHandle2 = @(block_struct) ...
semanticseg(block_struct.data,net,'OutputType','uint8');
blockyImage = blockproc(testImage, [windowSize windowSize], myFilterHandle2);
B = labeloverlay(testImage,blockyImage);
imshow(B)