clear all;
I = imread('input1.jpg');
imshow(I)
I=rgb2gray(I);
I=im2double(I);
BW1 = edge(I,'Canny');
imshow(BW1)

PercentOfPixelsNotEdges = .7; % Used for selecting thresholds
ThresholdRatio = .4;          % Low thresh is this fraction of the high.

% Calculate gradients using a derivative of Gaussian filter
[dx, dy] = smoothGradient(a, sigma);

% Calculate Magnitude of Gradient
magGrad = hypot(dx, dy);

% Normalize for threshold selection
magmax = max(magGrad(:));
if magmax > 0
    magGrad = magGrad / magmax;
end

% Determine Hysteresis Thresholds
[lowThresh, highThresh] = selectThresholds(thresh, magGrad, PercentOfPixelsNotEdges, ThresholdRatio, mfilename);

% Perform Non-Maximum Suppression Thining and Hysteresis Thresholding of Edge
% Strength
e = thinAndThreshold(dx, dy, magGrad, lowThresh, highThresh);
thresh = [lowThresh highThresh];