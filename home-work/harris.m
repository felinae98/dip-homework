close all;
clear;
clc

im = imread('./example-grey-small.png');
imshow(im);
imd = im2double(im);
dx_kernel = [-1, 0 1; -1. 0. 1; -1, 0, 1];
dy_kernel = dx_kernel';
I_x = imfilter(imd, dx_kernel);
I_y = imfilter(imd, dy_kernel);
% subplot(121)
% imshow(I_x);
% subplot(122)
% imshow(I_y);

g = fspecial('gaussian', 3 ,3);
I_x2 = imfilter(I_x.^2, g);
I_y2 = imfilter(I_y.^2, g);
% figure; imshow(I_x2);
% figure; imshow(I_y2);
I_xy = imfilter(I_x.*I_y, g);
% figure; imshow(I_xy);
% generate A, B, C

[size_x, size_y] = size(I_x2);
R = zeros(size_x, size_y);
k = 0.04;
for i=2:1:size_x-1
    for j=2:1:size_y-1
        I_x2s = sum(sum(I_x2(i-1:i+1, j-1:j+1)));
        I_y2s = sum(sum(I_y2(i-1:i+1, j-1:j+1)));
        I_xys = sum(sum(I_xy(i-1:i+1, j-1:j+1)));
        
        mat = [I_x2s, I_xys; I_xys,  I_y2s];
        R(i, j) = det(mat) - k*trace(mat).^2;
    end
end
figure; imshow(R)
