%lab11 - script used in the workshop
%   Used in MBM 2020/2021 for lab 11
%   Will be distributed through Canvas
%
%   Description: The lab applies the gaussian blur filter and blurring in the 
%                fourier domain on three images; tiger.png, leopard.png and 
%                face.png by using gaussian filter. The last part uses the 
%                difference of gaussian (DoG) technique for edge enhancement 
%                and blurring.
%
%   Other m-files required: face.png, tiger.png, leopard.png, gaussianfilter.m
%   
%   MAT-files required: none
%
%   Author: 2227572
%   email: vxz072@student.bham.ac.uk
%   Date: 08/06/2021
%
%   Last revision: $08/06/2021, 2227572, No Changes

%% Tiger 

clear all
% converts image to floating point
tiger=mat2gray(imread('tiger.png'));
% s=32;
% sigma=3; 

% x and y coordinates of the image
% x=-(s-1)/2:(s-1)/2;
% y=x;
% [X,Y]=meshgrid(x,y);
% G=exp(-(X.^2+Y.^2)/(2*sigma^2))/(2*pi*sigma^2);

% tiger convolution
tigerBlurred=conv2(tiger,gaussianfilter(3, 32),'same');

figure(1);
imshow(tigerBlurred) % to view image

% s=320;
% sigma=3;  
% x=-(s-1)/2:(s-1)/2;
% y=x;
% [X,Y]=meshgrid(x,y);
% G=exp(-(X.^2+Y.^2)/(2*sigma^2))/(2*pi*sigma^2);

% measures elapsed time
tic;tigerBlurred=conv2(tiger,gaussianfilter(3, 320),'same');toc
tic;tigerBlurredfft=ifftshift(ifft2(fft2(tiger).*fft2(gaussianfilter(3, 320))));toc

%% Task 1; face

face=mat2gray(imread('face.png'));
%  s=2048; % size
%  sigma=50;
%  x=-(s-1)/2:(s-1)/2;
%  y=x;
%  [X,Y]=meshgrid(x,y);
%  G=exp(-(X.^2+Y.^2)/(2*sigma^2))/(2*pi*sigma^2);

% convolution
faceBlurred5=conv2(face, gaussianfilter(5, 30), 'same');
faceBlurred15=conv2(face, gaussianfilter(15, 90), 'same');
faceBlurred30=conv2(face, gaussianfilter(30, 180), 'same');

% plots face.png with the different sigmas 
figure(2);
subplot(2,2,1);
imshow(face);
title('original image');
subplot(2,2,2);
imshow(faceBlurred5);
title('sigma=5, s=30');
subplot(2,2,3);
imshow(faceBlurred15);
title('sigma=15, s=90');
subplot(2,2,4);
imshow(faceBlurred30)
title('sigma=30, s=180');
sgtitle('Face.png with different sigma');

% imagesc of the different gaussian filters
figure(3);
subplot(2,3,1);
imagesc(gaussianfilter(5, 30));
title('sigma=5, s=30');
ylabel('filter size y coordinate');
xlabel('filter size x coordinate');

subplot(2,3,2);
imagesc(gaussianfilter(15, 90));
ylabel('filter size y coordinate');
xlabel('filter size x coordinate');
title('sigma=15, s=90');

subplot(2,3,3);
imagesc(gaussianfilter(30, 180));
ylabel('filter size y coordinate');
xlabel('filter size x coordinate');
title('sigma=30, s=180');
colormap('parula');

% gaussian usinf surf
subplot(2,3,4);
surf(gaussianfilter(5, 30));
title('sigma=5, s=30');
ylabel('filter size (y)');
xlabel('filter size (x)');
zlabel('amplitude');

subplot(2,3,5);
surf(gaussianfilter(15, 90));
title('sigma=15, s=90');
ylabel('filter size (y)');
xlabel('filter size (x)');
zlabel('amplitude');


subplot(2,3,6);
surf(gaussianfilter(30, 180));
title('sigma=30, s=180');
ylabel('filter size (y)');
xlabel('filter size (x)');
zlabel('amplitude');

colormap('parula');
sgtitle('Gaussian filters with different sigma for face.png');


% saves the image with sigma=30
imwrite(uint8(mat2gray(faceBlurred30).*255),'face_filtered.png','png');

% fourier domain
faceBlurredfft=ifftshift(ifft2(fft2(face).*fft2(gaussianfilter(30, 2048))));

figure(4);
imshow(faceBlurredfft);
colormap('gray');
title('Fourier transformed face.png sigma=30, s=2048');

%imshow(abs(faceBlurredfft-face));

% difference between face image using fft and gaussian filter
figure(5);
subplot(2,2,1);
imshow(faceBlurredfft);
title('1. Fourier transformed face.png (sigma=30, s=2048)');
colormap(gca, 'gray');

subplot(2,2,2);
imshow(abs(faceBlurredfft-face));
title('2. Difference between Gaussian filter and Fourier transform');
colormap(gca, 'parula');

subplot(2,2,3);
mesh(faceBlurred30);
xlabel('size (x)');
ylabel('size (y)');
zlabel('amplitude');
title('3. Gaussian blurred image (sigma=30)');

subplot(2,2,4);
mesh(faceBlurredfft);
xlabel('size (x)');
ylabel('size (y)');
zlabel('amplitude');
title('4. Fourier transformed image');

sgtitle('Effects of Fourrier Transform on face.png');

%% Leopard
leopard=mat2gray(imread('leopard.png'));
s=180;
x=-(s-1)/2:(s-1)/2;
y=x;
[X,Y]=meshgrid(x,y);

% creates 3 variables for each different sigmaPositive and sigmaNegative
% value
sigmaPositive1=1; 
sigmaNegative3=3; 

GPositive1=exp(-(X.^2+Y.^2)/(2*sigmaPositive1^2))/(sigmaPositive1^2);
GNegative3=exp(-(X.^2+Y.^2)/(2*sigmaNegative3^2))/(sigmaNegative3^2);

sigmaPositive3=3; 
sigmaNegative9=9; 

GPositive3=exp(-(X.^2+Y.^2)/(2*sigmaPositive3^2))/(sigmaPositive3^2);
GNegative9=exp(-(X.^2+Y.^2)/(2*sigmaNegative9^2))/(sigmaNegative9^2);

sigmaPositive10=10; 
sigmaNegative30=30; 

GPositive10=exp(-(X.^2+Y.^2)/(2*sigmaPositive10^2))/(sigmaPositive10^2);
GNegative30=exp(-(X.^2+Y.^2)/(2*sigmaNegative30^2))/(sigmaNegative30^2);

% difference of gaussian 
DOG1=GPositive1-GNegative3;
DOG2=GPositive3-GNegative9;
DOG3=GPositive10-GNegative30;

% convolution 
leopardEdges1=abs(conv2(leopard,DOG1,'same'));
leopardEdges2=abs(conv2(leopard,DOG2,'same'));
leopardEdges3=abs(conv2(leopard,DOG3,'same'));

% plots leopard.png for the three different values for
% sigmaPositive/Negative
figure(6);
subplot(2,2,1)
imshow(leopardEdges1)
title('sigmaPositive=1, sigmaNegative=3')
subplot(2,2,2)
imshow(leopardEdges2)
title('sigmaPositive=3, sigmaNegative=9')
subplot(2,2,3)
imshow(leopardEdges3)
title('sigmaPositive=10, sigmaNegative=30')
sgtitle('Leopard.png for different sigmaPositive and sigmaNegative values')

%% same process applied on the tiger.png

tiger=mat2gray(imread('tiger.png'));
s=180;
x=-(s-1)/2:(s-1)/2;
y=x;
[X,Y]=meshgrid(x,y);

% creates 3 variables for each different sigmaPositive and sigmaNegative
% value
sigmaPositive1=1; 
sigmaNegative3=3; 

GPositive1=exp(-(X.^2+Y.^2)/(2*sigmaPositive1^2))/(sigmaPositive1^2);
GNegative3=exp(-(X.^2+Y.^2)/(2*sigmaNegative3^2))/(sigmaNegative3^2);

sigmaPositive3=3; 
sigmaNegative9=9; 

GPositive3=exp(-(X.^2+Y.^2)/(2*sigmaPositive3^2))/(sigmaPositive3^2);
GNegative9=exp(-(X.^2+Y.^2)/(2*sigmaNegative9^2))/(sigmaNegative9^2);

sigmaPositive10=10; 
sigmaNegative30=30; 

GPositive10=exp(-(X.^2+Y.^2)/(2*sigmaPositive10^2))/(sigmaPositive10^2);
GNegative30=exp(-(X.^2+Y.^2)/(2*sigmaNegative30^2))/(sigmaNegative30^2);

% difference of gaussian 
DOG1=GPositive1-GNegative3;
DOG2=GPositive3-GNegative9;
DOG3=GPositive10-GNegative30;

% convolution 
tigerEdges1=abs(conv2(tiger,DOG1,'same'));
tigerEdges2=abs(conv2(tiger,DOG2,'same'));
tigerEdges3=abs(conv2(tiger,DOG3,'same'));

% plots tiger.png for the three different values for
% sigmaPositive/Negative
figure(7);
subplot(2,2,1)
imshow(tigerEdges1)
title('sigmaPositive=1, sigmaNegative=3')
subplot(2,2,2)
imshow(tigerEdges2)
title('sigmaPositive=3, sigmaNegative=9')
subplot(2,2,3)
imshow(tigerEdges3)
title('sigmaPositive=10, sigmaNegative=30')
sgtitle('Tiger.png for different sigmaPositive and sigmaNegative values')
%% Task 1 gaussianfilter function
function [G] = gaussianfilter(sigma, s)
% Gaussian filter
%   inputs: sigma is the standard deviation  
%   s is the size of the image. It should be an integer 6*sigma.
%   The output is the gaussian filter that is used for convolution
%           

% meshgrid
x=-(s-1)/2:(s-1)/2;
y=x;
[X,Y]=meshgrid(x,y);

% 2D gaussian
G=exp(-(X.^2+Y.^2)/(2*sigma^2))/(2*pi*sigma^2);

end
