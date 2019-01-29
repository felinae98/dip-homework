from PIL import Image
import numpy as np
from matplotlib import pyplot as plt
import math
from itertools import product

im_raw = Image.open("./example-grey-small.png")
im = np.array(im_raw)
size = im.shape
rotaion_angle = math.pi / 6
rotaion_mat = np.matrix([[math.cos(rotaion_angle), -math.sin(rotaion_angle), 0],
                        [math.sin(rotaion_angle), math.cos(rotaion_angle), 0],
                        [0, 0, 1]])
shear_mat = np.matrix([[1, 0.3, 0], [0, 1, 0], [0, 0, 1]])
shift_mat = np.matrix([[1, 0, 123], [0, 1, 0], [0, 0, 1]])
affine_mat = rotaion_mat * shear_mat * shift_mat
revert_affine_mat = affine_mat.I
print(size)
print(affine_mat)

max_pos = [0, 0]
for i, j in product([0, size[0] - 1], [0, size[1] - 1]):
    trans_pos = np.array(affine_mat * np.matrix([i, j, 1]).transpose())
    if trans_pos[0][0] > max_pos[0]:
        max_pos[0] = trans_pos[0][0]
    if trans_pos[1][0] > max_pos[1]:
        max_pos[1] = trans_pos[1][0]

max_size = tuple(map(lambda x: math.ceil(x)+1, max_pos))[:2]
new_im = np.zeros(max_size)

cnt = 0
for i in range(max_size[0]):
    for j in range(max_size[1]):
        source_pos = np.array(revert_affine_mat * np.matrix([i, j, 1]).transpose())
        source_x = source_pos[0][0]
        source_y = source_pos[1][0]
        if source_x <0 or source_x > size[0] - 1 or source_x < 0 or source_y > size[1] - 1:
            new_im[i][j] = 255
            continue
        # 插值
        a = im[math.floor(source_x)][math.floor(source_y)] * (math.ceil(source_y) - source_y) + \
            im[math.floor(source_x)][math.ceil(source_y)] * (source_y - math.floor(source_y))
        b = im[math.ceil(source_x)][math.floor(source_y)] * (math.ceil(source_y) - source_y) + \
            im[math.ceil(source_x)][math.ceil(source_y)] * (source_y - math.floor(source_y))
        target = a * (math.ceil(source_x) - source_x) + b * (source_x - math.floor(source_x))
        new_im[i][j] = int(target)
new_im = Image.fromarray(np.uint8(new_im))
new_im.show()