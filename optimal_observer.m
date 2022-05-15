%Lab1 - Implementation of 2AFC experiment with optimal observer.
%   Used in Mind Brain and Modules 2021 for workshop 1.
%   Will be submitted through Canvas for grading.
%   Will be assessed as a pass/fail assessment.
%
%   Description:
%       Lab1 models an optimal observer in a psychophysical experiment.
%       The experiment: At each trial, a standard stimulus and a comparison
%       stimulus are presented. The comparison stimulus is chosen at random
%       The optimal observer has a representation of the two sensed values,
%       and its algorithm is that his response should be 0 or 1. The values
%       are corrupted by Gaussian noise. The script calculates the average
%       response produced for each comparison stimulus.
%
%   Other m-files required: none.
%   MAT-files required: none.
%

%   Author: 2227572
%   email: vxz072@student.bham.ac.uk
%   Date: 15/02/2021
%
%   Last revision: 15/02/07, 2227572, no changes.


%% Initialization.

clear all
close all
clc

rng('shuffle');

%% Variables.

nTrials = 5000;
standardNoNoise = 4;
comparisonValues = 1:1:7;
nComparisons = length(comparisonValues);
standardDeviationNoise = 1.5;

%% Variable preallocation.

data = nan(2,nTrials);
meanResponsesForComparison = nan(1,nComparisons);

%% Experiment.
for trial=1:nTrials
    
    % Stimulus presentation.
    % Used randomization with replacement.
    comparisonTrialNoNoise = comparisonValues(randi(nComparisons));
    
    % Noise corruption.
    comparisonTrial = comparisonTrialNoNoise + randn(1) * standardDeviationNoise;
    standardTrial = standardNoNoise + randn(1) * standardDeviationNoise;
    
    % Decision.
    if comparisonTrial > standardTrial
        response = 1; 
    else
        response = 0;
    end
    
    % Data storage.
    data(:,trial) = [comparisonTrialNoNoise response];
    
end


%% Data analysis.
for c=1:nComparisons
    
    % Mean response calculated for each of the standard values.
    meanResponsesForComparison(c) = mean(data(2,data(1,:) == comparisonValues(c)));
    
end

%% Plot of mean response.

% Plot of cumulative Gaussian.
figure(2);
plot(normcdf(meanResponsesForComparison), 'm');

xlabel('Mean Responses for Comparison');
ylabel('Comparison Stimuli');

% Set of stimuli.
xticks(1:7); 

% Axis bounds for the responses between 0 and 1 and for comparison stimuli from 1 to 7.
axis([1 7 0 1]);

%% PROBIT analysis.

% Limits values between 1/5000, 1-1/5000 range using the normalize function.
limitedMeanResponses = normalize(meanResponsesForComparison, 'range', [1/5000, 1-1/5000]);

% Transforms the responses in PROBIT units.
probitMeanResponses = norminv(limitedMeanResponses);

% Fits a line through the data.
% y is the transformed responses and x is the comparison values.
regressionMeanResponses = regress(probitMeanResponses', [ones(7, 1)'; comparisonValues]');


% Cumulative Gaussian with the response criterion and variance as inputs.
figure(2);
plot(normcdf(limitedMeanResponses, - regressionMeanResponses(1) / regressionMeanResponses(2), ...
    1 / regressionMeanResponses(2)), 'b');
