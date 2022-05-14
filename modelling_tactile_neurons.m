%lab8 - Modeling First-Order tactile neurons with TouchSim (Saal et al., 2017)
%   Used in MBM 2020/2021 to demonstrate scripting for workshop 8
%   Will be distributed through Canvas
%
%   Description:
%       lab8 uses TouchSim_v1 to model the activity of first-order neurons
%       in response to virtual stimuli. The main task is to test how 
%       the manipulation of a single stimulus parameter affects
%       the firing rate of virtual neurons
%       You will have to come up with a simple research question 
%       and run a virtual experiment to test it
%
%       %%The modified code for the lab starts on line 232%%
%
%   Other m-files required: TouchSim_v1 package
%   MAT-files required: none
%

%   Author: 2227572
%   email: vxz072@student.bham.ac.uk
%   Date: 8/06/2021 
%
%   Last revision: $08/06/2021, 2227572, No changes

%% 1. Create population of virtual neurons 

clc
clear all;

hand = affpop_hand('D2d');

% grid for afferent location/step (based on literature):
% spacing for SA1 = ~ 1.2 mm % density
% spacing for RA = ~ 0.8
% spacing for PC = ~ 2

% this determines the location of the afferents on the fingertips 
[xRA,yRA] = meshgrid(-5:0.8:5.5, -5:0.8:5);
[xSA1,ySA1] = meshgrid(-5:1.2:5, -5:1.2:5);
[xPC,yPC] = meshgrid(-5:2:5, -5:2:5);

% AfferentPopulation creates the fingertip
hand = AfferentPopulation();
hand.add_afferents('RA',[xRA(:) yRA(:)]);
hand.add_afferents('SA1',[xSA1(:) ySA1(:)]);
hand.add_afferents('PC',[xPC(:) yPC(:)]);

n_SA1 = sum(hand.iSA1);
n_RA = sum(hand.iRA);
n_PC = sum(hand.iPC);
n_aff = n_SA1 + n_RA + n_PC;

figure(1)
plot(hand,[],'region','D2d') % region D2d only (tip of index finger)
% plot(a) % whole hand

%% 2. Create virtual stimulus

% stim_sine
% s = stim_sine(freq,amp,phase,len,loc,samp_freq,ramp_len,pin_size,pre_indent)
% 
% freq: Vector of frequencies in Hz.
% amp: Vector of amplitudes in mm.
% phase: Vector of phases in degrees.
% len: Stimulus duration in s, default: 1
% loc: Stimulus location in mm, default |[0 0]|.
% samp_freq: Sampling frequency in Hz, default 5000.
% ramp_len: Duration of on and off ramps in s, default 0.05.
% pin_size: Probe radius in mm.
% pre_indent: Static indentation throughout trial, default: 0

s_sine = stim_sine(100, 1, 0, 1, [0 0], 2500,  0.1, 0.5);

figure(2)
plot(s_sine)

%% stim_ramp
% s = stim_ramp(amp,len,loc,samp_freq,ramp_len,ramp_type,pin_size,pre_indent)

% ramp_type: 'sine' or 'lin'
s_ramp = stim_ramp(2,1,[0 0],2500,[],'sine',0.1);

figure(3)
plot(s_ramp)

%% shape_bar
% shape = shape_bar(width,height,angle,pins_per_mm);
% 
% width: width of the bar in mm, default 5 mm.
% height: height of the bar in mm, default 0.5 mm 
% angle: Rotation angle of bar in degrees, default 0.
% pins_per_mm: Number of pins per mm, default 10.

shape = shape_bar(5, 1, 90, 10);

figure(4)
plot(shape(:,1), shape(:,2),'o')

s_shape = stim_indent_shape(shape, s_ramp);

figure(5)
plot(s_shape)

%% shape_letter
% shape = shape_letter(letter, width, pins_per_mm)

% letter: string, e.g. 'A'
% width: width of letter in mm, default = 5 mm
% pins_per_mm: Number of pins per mm, default 10.

shape = shape_letter('O',20);

figure(6)
plot(shape(:,1), shape(:,2),'o')

s_letter = stim_indent_shape(shape, s_ramp);

figure(7)
plot(s_letter)
%% 3. Simulate response

% ramp stimulus, single pin
r_letter = hand.response(s_letter);
plot(r_letter) % raster plot

% extract absolute firing rate
rates = r_letter.rate; % all together

rates_RA = rates(hand.iRA); % RA
rates_SA1 = rates(hand.iSA1); % SA1
rates_PC = rates(hand.iPC); % PC

% compute adjusted rate wrt max rate for each afferent type
rates(hand.iRA) = rates(hand.iRA)/max(rates(hand.iRA));
rates(hand.iSA1) = rates(hand.iSA1)/max(rates(hand.iSA1));
rates(hand.iPC) = rates(hand.iPC)/max(rates(hand.iPC));

% plot adjusted firing rate on virtual hand
figure(8)
plot(hand,[],'rate',rates)

% bar plot spikes/neurons
figure(9)
subplot(3,1,1)
b = bar(rates_RA,'FaceColor','flat');
b.CData = [0 0.4 0.8];
ylabel('# spikes','FontSize',15)
title('RA','FontSize',15)

subplot(3,1,2)
b = bar(rates_SA1,'FaceColor','flat');
b.CData = [0.4 0.6 0.2];
ylabel('# spikes','FontSize',15)
title('SA1','FontSize',15)

subplot(3,1,3)
b = bar(rates_PC,'FaceColor','flat');
b.CData = [0.8 0.5 0.1];
xlabel('Neuron ID','FontSize',15)
ylabel('# spikes','FontSize',15)
title('PC','FontSize',15)

%% 4. Examples
% Simulation with 2 frequencies 100 and 50 Hz
% - Which type of afferent is more tuned to the change of frequency?
clc
clear all

% 4.1 Create hand/finger model

[xRA,yRA] = meshgrid(-5:0.8:5,-5:0.8:5);
[xSA1,ySA1] = meshgrid(-5:1.2:5,-5:1.2:5);
[xPC,yPC] = meshgrid(-5:2.1:5,-5:2:5);

hand = AfferentPopulation();
hand.add_afferents('RA',[xRA(:) yRA(:)]);
hand.add_afferents('SA1',[xSA1(:) ySA1(:)]);
hand.add_afferents('PC',[xPC(:) yPC(:)]);

% 4.2 Create stimulus, single pin, two frequencies
s_sine100 = stim_sine(100, 1, 0, 1, [0 0], 2500,  0.1, 1); % 100
s_sine50 = stim_sine(50, 1, 0, 1, [0 0], 2500,  0.1, 1); % 50

% 4.3 Simulate response

% sine stimulus, single pin, 100Hz
r_sine100 = hand.response(s_sine100);

figure(10)
plot(r_sine100) % raster plot

% sine stimulus, single pin, 50Hz
r_sine50 = hand.response(s_sine50);

figure(11)
plot(r_sine50) % raster plot

% extract absolute firing rate
rates100 = r_sine100.rate; % all units
rates50 = r_sine50.rate;

rates_RA_100 = rates100(hand.iRA); % RA
rates_RA_50 = rates50(hand.iRA); % RA

rates_SA1_100 = rates100(hand.iSA1); % RA
rates_SA1_50 = rates50(hand.iSA1); % RA

rates_PC_100 = rates100(hand.iPC); % PC
rates_PC_50 = rates50(hand.iPC); % PC

figure(12)
subplot(3,1,1)
plot(rates_RA_100); hold on
plot(rates_RA_50)
title('RA','FontSize',15)
legend({'100 Hz','50 Hz'})
ylabel('# spikes','FontSize',15)

subplot(3,1,2)
plot(rates_SA1_100); hold on
plot(rates_SA1_50)
title('SA1','FontSize',15)
ylabel('# spikes','FontSize',15)

subplot(3,1,3)
plot(rates_PC_100); hold on
plot(rates_PC_50)
title('PC','FontSize',15)
xlabel('Neuron ID','FontSize',15)
ylabel('# spikes','FontSize',15)

%% TASK 1: create an empty hand and afferent neurons
% stimulus that was changed was the shape; compared the response of the 
% afferents using two letters; O and I
clear all
clc 

% this determines the location of the afferents on the fingertips 
[xRA,yRA] = meshgrid(-5.05:0.8:5.02, -5.03:0.8:5.05);
[xSA1,ySA1] = meshgrid(-5.02:1.2:5.05, -5.03:1.2:5.05);
[xPC,yPC] = meshgrid(-5.02:2:5.01, -5.02:2:5.01);

% randomly distributed afferents; divides size of afferents with
% afferent density and a number between 1-5 that was tailored for best results
xRA = xRA+randn(size(xRA))/0.8/3;  
yRA = yRA+randn(size(yRA))/0.8/3;
xSA1 = xSA1+randn(size(xSA1))/1.2/4; 
ySA1 = ySA1+randn(size(ySA1))/1.2/4; 
xPC= xPC+randn(size(xPC))/2/2; 
yPC= yPC+randn(size(yPC))/2/2; 

% AfferentPopulation creates the fingertip
hand = AfferentPopulation();
hand.add_afferents('RA',[xRA(:) yRA(:)]);
hand.add_afferents('SA1',[xSA1(:) ySA1(:)]);
hand.add_afferents('PC',[xPC(:) yPC(:)]);

n_SA1 = sum(hand.iSA1);
n_RA = sum(hand.iRA);
n_PC = sum(hand.iPC);
n_aff = n_SA1 + n_RA + n_PC;

% plot
figure(13)
plot(hand,[],'region', 'D2d') 
title('Afferent population on fingertips')

%% TASK 2: Creating the letter stimuli
s_ramp = stim_ramp(2,1,[0 0],2500,[],'sine',0.1);

shape1 = shape_bar(10, 3, 90, 20);
shape2 = shape_bar(10, 3, 90, 20);

s_shape1 = stim_indent_shape(shape1, s_ramp);
s_shape2 = stim_indent_shape(shape2, s_ramp);

figure(14)
plot(s_shape1)
figure(15)
plot(s_shape2)

% defining the letters
shape1 = shape_letter('O',10, 20);
shape2 = shape_letter('I',10, 20);

s_letter1 = stim_indent_shape(shape1, s_ramp);
s_letter2 = stim_indent_shape(shape2, s_ramp);

figure(16)
plot(s_letter1)
figure(17)
plot(s_letter2)
%% TASK 3: Creating the response
% raster plot for letter O
figure(18)
r_letter1 = hand.response(s_letter1);
plot(r_letter1) 
title('Afferent response to Letter O')
legend('RA', 'SA1', 'PC')

% raster plot for letter I
figure(19)
r_letter2 = hand.response(s_letter2);
plot(r_letter2) 
title('Afferent response to Letter I')
legend('RA', 'SA1', 'PC')

% Calculating the firing rate
rates1 = r_letter1.rate;
rates2 = r_letter2.rate;

% letter O
rates1_RA = rates1(hand.iRA); % RA
rates1_SA1 = rates1(hand.iSA1); % SA1
rates1_PC = rates1(hand.iPC); % PC

% letter I
rates2_RA = rates2(hand.iRA); % RA
rates2_SA1 = rates2(hand.iSA1); % SA1
rates2_PC = rates2(hand.iPC); % PC

% compute adjusted rate with max rate for each afferent type
rates1_RA(hand.iRA) = rates1(hand.iRA)/max(rates1(hand.iRA));
rates1_SA1(hand.iSA1) = rates1(hand.iSA1)/max(rates1(hand.iSA1));
rates1_PC(hand.iPC) = rates1(hand.iPC)/max(rates1(hand.iPC));

rates2_RA(hand.iRA) = rates2(hand.iRA)/max(rates2(hand.iRA));
rates2_SA1(hand.iSA1) = rates2(hand.iSA1)/max(rates2(hand.iSA1));
rates2_PC(hand.iPC) = rates2(hand.iPC)/max(rates2(hand.iPC));

% bar plots for letter O
figure(20)
subplot(3,1,1)
b = bar(rates1_RA,'FaceColor','flat');
b.CData = [0 0.4 0.8];
ylabel('# spikes','FontSize',15)
title('RA','FontSize',15)

subplot(3,1,2)
b = bar(rates1_SA1,'FaceColor','flat');
b.CData = [0.4 0.6 0.2];
ylabel('# spikes','FontSize',15)
title('SA1','FontSize',15)

subplot(3,1,3)
b = bar(rates1_PC,'FaceColor','flat');
b.CData = [0.8 0.5 0.1];
xlabel('Neuron ID','FontSize',15)
ylabel('# spikes','FontSize',15)
title('PC','FontSize',15)
sgtitle('Firing rate for letter O')

% bar plots for letter I 
figure(21)
subplot(3,1,1)
b = bar(rates2_RA,'FaceColor','flat');
b.CData = [0 0.4 0.8];
ylabel('# spikes','FontSize',15)
title('RA','FontSize',15)

subplot(3,1,2)
b = bar(rates2_SA1,'FaceColor','flat');
b.CData = [0.4 0.6 0.2];
ylabel('# spikes','FontSize',15)
title('SA1','FontSize',15)

subplot(3,1,3)
b = bar(rates2_PC,'FaceColor','flat');
b.CData = [0.8 0.5 0.1];
xlabel('Neuron ID','FontSize',15)
ylabel('# spikes','FontSize',15)
title('PC','FontSize',15)
sgtitle('Firing rate for letter I') 

% compare means of rates for letter O and I
h = ttest(rates1,rates2);

