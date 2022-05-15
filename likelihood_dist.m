%Lab1 - Implementation of grid sampling Bayesian inference. 
%   Used in Mind Brain and Modules 2021 for workshop 2.
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
%   Date: 22/02/2021
%
%   Last revision: 22/02/07, 2227572, no changes.

clear all
close all
clc

%% Prior and likelihood distributions.

% Range of samples.
samples = (-20:0.01:20);
meanPrior = 0;
standardDeviationPrior = 2;
meanLikelihood = 2;
standardDeviationLikelihood = 1;

% Prior Gaussian distribution.
priorDistribution = normpdf(samples,meanPrior,standardDeviationPrior);
figure(1);
plot(samples, priorDistribution, 'm')
title('Prior Distribution');
xlabel('Samples');
ylabel('Probability');

% Likelihood Gaussian distribution.
likelihoodDistribution = normpdf(samples,meanLikelihood,standardDeviationLikelihood);
figure(2);
plot(samples, likelihoodDistribution, 'g');
title('Likelihood Distribution');
xlabel('Samples');
ylabel('Probability');

% Plot for both prior and likelihood distributions.
figure(3);
plot(samples, priorDistribution, 'm');
xlabel('Samples');
ylabel('Probability');
hold on 
plot(samples, likelihoodDistribution, 'g');

%% Posterior Distribution.

% Multiplies the prior and likelihood distributions.
posteriorDistribution = priorDistribution .* likelihoodDistribution;
plot(samples, posteriorDistribution);

% Normalization.
posteriorDistribution = posteriorDistribution/sum(posteriorDistribution) / .01;

% Finds the maximum value.
meanPosterior = samples(find(max(posteriorDistribution) == posteriorDistribution));
meanLikelihood = samples(find(max(likelihoodDistribution) == likelihoodDistribution));

% Standard deviation.
standardDeviationPosterior = std(posteriorDistribution);



