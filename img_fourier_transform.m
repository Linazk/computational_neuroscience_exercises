%Independent lab - script used in the workshop
%   Used in MBM 2020/2021 for independent lab
%   Will be distributed through Canvas
%
%   Description: The script applies the Fourier transform in the bird.png 
%                image and is used for the independent lab (essay) to demostrate 
%                how images are transferred in the Fourier domain. 
%                        
%
%   Other m-files required: bird.png 
%                           image link: https://live.staticflickr.com/1189/4730847652_a3c6eb881c_b.jpg
%   MAT-files required: none
%
%   Author: 2227572
%   email: vxz072@student.bham.ac.uk
%   Date: 08/06/2021
%
%   Last revision: $08/06/2021, 2227572, No Changes

clear all 

% reads image
bird = imread('bird.png');

% fourier transform
birdFourierTransformed = fft2(bird);

% plots the original bird.png and again in the Fourier domain
figure(1);
subplot(1,2,1);
imshow(bird)
title('1. Original image')

subplot(1,2,2);
imshow(log(abs(fftshift(birdFourierTransformed)) + 1), [])
title('2. Image in the Fourier domain')

figure(2);
imshow(repmat(bird, 2, 2))
