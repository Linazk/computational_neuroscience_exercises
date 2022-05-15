%Lab3 - Implementation of grid sampling Bayesian inference.
%   Used in Mind Brain and Modules 2021 for workshop 3.
%   Will be submitted through Canvas for grading.
%   Will be assessed as a pass/fail assessment.
%
%   Description:
%      Samples from a prior and likelihood distribution using a grid based
%      approach.
%      The experiment: Low-contrast stimuli are perceived as
%      moving slower than high-contrast stimuli. This phenomenon is
%      examined using Bayesian inference by calculationg a prior (prior
%      beliefs) and a likelihood distribution which result in the posterior
%      distribution and lastly in the decision of the observer.
%
%   Other m-files required: none.
%   MAT-files required: none.
%
%   Author: 2227572
%   email: vxz072@student.bham.ac.uk
%   Date: 22/04/2021
%
%   Last revision: 22/04/21, 2227572, no changes.

%% Initialization
clear all
close all
clc

angles = -180:1:180;

%% Variables
audio = -60;
vision = -60;

% Reliability of vision and audio is the inverse of the variance.
reliabilityAudio = 0.025;
reliabilityVision = 0.05;


% Calculating the variance.
varianceAudio = 1 / reliabilityAudio;
varianceVision = 1 / reliabilityVision;

% Standard Deviation of audio and vision.
stdAudio = sqrt(varianceAudio);
stdVision = sqrt(varianceVision);

% Likelihood and posterior distributions.

likelihoodAudio = normpdf(angles, audio, stdAudio);
likelihoodVision = normpdf(angles, vision, stdVision);

posterior = likelihoodAudio .* likelihoodVision;

% Normalization.
likelihoodAudio = likelihoodAudio / sum(likelihoodAudio);
likelihoodVision = likelihoodVision / sum(likelihoodVision);
posterior = posterior / sum(posterior);

% Plot of all the distributions.
figure(1);
cla
plot(angles, likelihoodAudio)
hold on
plot(angles, likelihoodVision)
hold on
plot(angles, posterior)
hold off

%% Estimating the parameters of the posterior.

% Maximum of audio and vision.
maximumAudio = angles(find(likelihoodAudio == max(likelihoodAudio)));
maximumVision = angles(find(likelihoodVision == max(likelihoodVision)));

% Maximum of the posterior distribution.
maximumPosterior = angles(find(posterior == max(posterior)));

% Calculating the standard deviation.
varianceAudio = sum(likelihoodAudio .* (angles - maximumAudio).^2);
varianceVision = sum(likelihoodVision .* (angles - maximumVision).^2);
varianceDistribution = sum(posterior .* (angles - maximumPosterior).^2);

reliabilityAudio = 1 / varianceAudio;
reliabilityVision = 1 / varianceVision;
predictedReliabilityPosterior = reliabilityAudio + reliabilityVision;

%% Bivariate distributions with a coupling prior.

[angles_a, angles_v] = meshgrid(-180:1:180, -180:1:180);

% Constant value.
w = 1;
% Standard defviation of the prior.
sigma_p = 10;

% Coupling prior. 
prior = w+exp( - 1/4 * (angles_a.^2 - ...
    2*angles_a.*angles_v + angles_v.^2) /sigma_p^2);

G=exp( - 1/2 *((angles_a-mu_a).^2/sigma_a^2  + ...
    (angles_v-mu_v).^2/sigma_v^2 ));

prior = prior / sum(prior);

% Visualization.
surface(angles_a,angles_v,G)
shading interp
colormap gray
axis equaltight






















