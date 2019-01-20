clear;close all;clc
im = imread("../example-grey-small.png");
% imshow(im);

theta = pi / 6;
rot_mat = [cos(theta), -sin(theta), 0;
    sin(theta), cos(theta), 0;
    0, 0, 1];
shear_mat = [1, 0.3, 0; 0, 1, 0; 0, 0, 1];
affine_mat = rot_mat * shear_mat;
[raw_x, raw_y] = size(im);

maxx = 0; maxy = 0; minx = 0; miny = 0;
for x = [1 raw_x]
    for y = [1 raw_y]
        cood = affine_mat * [x; y; 1];
        maxx = max(cood(1), maxx);
        minx = min(cood(1), minx);
        maxy = max(cood(2), maxy);
        miny = min(cood(2), miny);
    end
end

shift_mat = [1, 0, abs(min(0, minx)); 0, 1, abs(min(0, miny)); 0, 0, 1];
T = shift_mat * rot_mat * shear_mat;
inv_T = inv(T);
maxx2 = 0; maxy2 = 0; minx2 = 0; miny2 = 0;
for x = [1 raw_x]
    for y = [1 raw_y]
        cood2 = T * [x; y; 1];
        disp(cood2)
        maxx2 = max(cood2(1), maxx2);
        minx2 = min(cood2(1), minx2);
        maxy2 = max(cood2(2), maxy2);
        miny2 = min(cood2(2), miny2);
    end
end

size_x = ceil(maxx2); size_y = ceil(maxy2);
new_im = zeros(size_x, size_y);
for x=1:size_x
    for y=1:size_y
        raw_pos = inv_T * [x;y;1];
        sx = raw_pos(1); sy = raw_pos(2);
        if sx < 1  || sy < 1 || sx > raw_x || sy > raw_y
            new_im(x,y) = 255;
            continue
        end
        % insert value
        %         a = im(floor(sx),floor(sy)) * (ceil(sy) - sy) + ...
        %             im(floor(sx),ceil(sy)) * (sy - ceil(sy));
        %         b = im(ceil(sx),floor(sy)) * (ceil(sy) - sy) + ...
        %             im(ceil(sx),ceil(sy)) * (sy - floor(sy));
        %         target = a * (ceil(sx)-sx) + b * (sx-floor(sx));
        alpha = im(floor(sx), floor(sy)); beta = im(floor(sx), ceil(sy));
        galma = im(ceil(sx), floor(sy)); theta = im(ceil(sx), ceil(sy));
        p = sy - floor(sy); q = sx - floor(sx);
        target = (alpha*(1-p)+beta*p) * (1-q) + ...
            (galma*(1-p)+theta*p) * (q);
        new_im(x,y)=target;
    end
end
imshow(uint8(new_im))
