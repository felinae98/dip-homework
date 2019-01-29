clc
clear
close all

im = im2double(imread('../example-grey-small.png'));
b_kernel = fspecial('gaussian', 5, 3);
blurred = imfilter(im, b_kernel, 'conv', 'circular');
imshow(blurred);

recv_im1 = deconvwnr(blurred, b_kernel, 0);
figure; imshow(recv_im1);

noise_var = 0.0001;
blurred_noise = imnoise(blurred, 'gaussian', 0, noise_var);
figure; imshow(blurred_noise);

recv_im2 = deconvwnr(blurred_noise, b_kernel, 0);
figure; imshow(recv_im2);
sigal_var = var(im(:));
recv_im3 = deconvwnr(blurred_noise, b_kernel, noise_var / sigal_var);
figure; imshow(recv_im3);