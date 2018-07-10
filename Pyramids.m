clc
clear all
close all
A = imread('Image.bmp');
 
%====================GAUSSIAN PYRAMID=====================
A1 = zeros (954/2, 1274/2); % 
A2 = zeros (958,1278); % matrix to be used for level 1 upsampling, is A1 with even rows and columns zeroes, is already padded
A5 = zeros (481,641);% matrix to be used for level 2 upsampling, is A6 with even rows and columns zeroes, is already padded
A8 = zeros (243, 323); % matrix to be used for level 3 upsampling, is A9 with even rows and columns zeroes, is already padded
A11 = zeros (124, 164); % matrix to be used for level 4 upsampling, is A12 with even rows and columns zeroes, is already padded
p = 1;
q = 1;
 
% original image
figure
imshow(A);
title('ORIGINAL IMAGE');
 
% level 1
kernel = (1/16).*[1 2 1; 2 4 2 ; 1 2  1];
A3 = padarray (A, [1 1], 0);
A3 = padarray (A3, [1 1], 0);
for i = 3: 956
    q = 1;
    for j = 3:1276
        temp = double(A3(i-1:i+1,j-1:j+1));
        if (mod(j, 2) ~= 0 && mod(i, 2) ~= 0)
            A2(i,j) = sum(sum(round(temp .* kernel)));
        end
        if (A2(i,j) ~= 0)
            A1(p,q) = A2(i,j);
            q = q + 1;
        end
    end
    if (mod(i,2) ~= 0)
        p = p + 1;
    end
end
% imshowpair(A, A1, 'montage')
m = size(A,1);
n = size(A1,1);
figure
imshow(uint8(A1))
title('GAUSSIAN PYRAMID LEVEL 1')
G1 = cat(1, A1, zeros((m-n), size(A1,2)));
 
 
 % level 2
p = 1;
A4 = padarray (A1, [1 1], 0);
A4 = padarray (A4, [1 1], 0);
for i = 3: 479
    q = 1;
    for j = 3:639
        temp = double(A4(i-1:i+1,j-1:j+1));
        if (mod(j, 2) ~= 0 && mod(i, 2) ~= 0)
            A5(i,j) = sum(sum(round(temp .* kernel)));
        end
        if (A5(i,j) ~= 0)
            A6(p,q) = A5(i,j); % level 2 image matrix
            q = q + 1;
        end
    end
    if (mod(i,2) ~= 0)
        p = p + 1;
    end
end
figure
imshow(uint8(A6))
title('GAUSSIAN PYRAMID LEVEL 2')
n = size(A6,1);
G2 = cat(1, A6, zeros((m-n), size(A6,2)));
 
 
 % level 3
p = 1;
A7 = padarray (A6, [1 1], 0);
A7 = padarray (A7, [1 1], 0);
for i = 3: 241
    q = 1;
    for j = 3:321
        temp = double(A7(i-1:i+1,j-1:j+1));
        if (mod(j, 2) ~= 0 && mod(i, 2) ~= 0)
            A8(i,j) = sum(sum(round(temp .* kernel)));
        end
        if (A8(i,j) ~= 0)
            A9(p,q) = A8(i,j); % level 3 image matrix
            q = q + 1;
        end
    end
    if (mod(i,2) ~= 0)
        p = p + 1;
    end
end
 
figure
imshow(uint8(A9))
title('GAUSSIAN PYRAMID LEVEL 3')
n = size(A9,1);
G3 = cat(1, A9, zeros((m-n), size(A9,2)));
 
 
 % level 4
p = 1;
A10 = padarray (A9, [1 1], 0);
A10 = padarray (A10, [1 1], 0);
for i = 3: 122
    q = 1;
    for j = 3:162
        temp = double(A10(i-1:i+1,j-1:j+1));
        if (mod(j, 2) ~= 0 && mod(i, 2) ~= 0)
            A11(i,j) = sum(sum(round(temp .* kernel)));
        end
        if (A11(i,j) ~= 0)
            A12(p,q) = A11(i,j); % level 4 image matrix
            q = q + 1;
        end
    end
    if (mod(i,2) ~= 0)
        p = p + 1;
    end
end
 
figure
imshow(uint8(A12))
title('GAUSSIAN PYRAMID LEVEL 4')
n = size(A12,1);
G4 = cat(1, A12, zeros((m-n), size(A12,2)));
 
G = A;
G = uint8(cat(2, G, G1, G2, G3, G4));
figure
imshow (G)
title('GAUSSIAN PYRAMID ALL 5 LEVELS TOGETHER')
 
 
%================LAPLACIAN PYRAMID===================
kernel = kernel*4;
B1 = zeros(958,1278);
 
% level 1
for i = 3:956
    for j = 3:1276
%         if (mod(i,2)~=0)
            temp = double(A2(i-1:i+1,j-1:j+1));
            B1(i,j) = sum(sum(round (kernel .* temp)));
%         end
    end
end
       
B1 = uint8(B1(3:end-2, 3:end-2));
L1 = (abs(A - B1));
figure
imshow(uint8(L1))
title('LAPLACIAN PYRAMID LEVEL 1')
% L1 = ceil((256/max(max(L1))*L1)); % level 1 laplacian pyramid
 
% level 2
B2 = zeros(481, 641);
 
for i = 3:479
    for j = 3:639
%         if (mod(i,2)~=0)
            temp = double(A5(i-1:i+1,j-1:j+1));
            B2(i,j) = sum(sum(round (kernel .* temp)));
%         end
    end
end
       
B2 = uint8(B2(3:end-2, 3:end-2));
L2 = (abs(uint8(A1) - B2));
 L2 = ceil((256/max(max(L2))*L2)); % level 2 laplacian pyramid
figure
imshow(uint8(L2))
title('LAPLACIAN PYRAMID LEVEL 2')
n = size(L2,1);
L2 = cat(1, L2, zeros((m-n), size(L2,2)));
 
% level 3
B3 = zeros(243, 323);
 
for i = 3:241
    for j = 3:321
%         if (mod(i,2)~=0)
            temp = double(A8(i-1:i+1,j-1:j+1));
            B3(i,j) = sum(sum(round (kernel .* temp)));
%         end
    end
end
       
B3 = uint8(B3(3:end-2, 3:end-2));
L3 = (abs(uint8(A6) - B3));
 L3 = ceil((256/max(max(L3))*L3)); % level 3 laplacian pyramid
figure
imshow(uint8(L3))
title('GAUSSIAN PYRAMID LEVEL 3')
n = size(L3,1);
L3 = cat(1, L3, zeros((m-n), size(L3,2)));
 
 
% level 4
B4 = zeros(124, 164);
 
for i = 3:121
    for j = 3:162
%         if (mod(i,2)~=0)
            temp = double(A11(i-1:i+1,j-1:j+1));
            B4(i,j) = sum(sum(round (kernel .* temp)));
%         end
    end
end
       
B4 = uint8(B4(3:end-2, 3:end-2));
L4 = (abs( uint8(A9) - B4));
 L4 = ceil((256/max(max(L4))*L4)); % level 4 laplacian pyramid
figure
imshow(uint8(L4))
title('LAPLACIAN PYRAMID LEVEL 4')
n = size(L4,1);
L4 = cat(1, L4, zeros((m-n), size(L4,2)));
