clc;
clear;
close all;

%% main estimate k
% The bisection method cannot be used because the least squares error is always greater than
% or equal to zero (≥0) and typically not equal to zero (≠0). Thus, the function does not have 
% a root at zero, which is a requirement for the bisection method.
% Load Data
load('trajectory_data.mat'); 
v0 = 50; % Initial velocity 
x0 = 0;
y0 = 0;
g = 9.81;


x_data = x_data + 0.01*randn;
y_data = y_data + 0.01*randn;

k_left = 0;
k_right = 1;
k_span = k_left:0.001:k_right;

J_squre = @(k) costXYsqureerror(x_data, y_data, theta_span, v0, x0, y0, g, k);

% goldenSectionSearch find minimum
[k_goldenSectionSearch,iteration_time] = goldenSectionSearch(k_left, k_right, J_squre, 1e-6, 1e4);

% Display the result of the first optimization
disp(['goldenSectionSearch k: ', num2str(k_goldenSectionSearch)])

% goldenSectionSearchself find minimum
%k_goldenSectionSearch1 = goldenSectionSearch1(k_left, k_right, J_squre, 1e-6);

% % Display the result of the first optimization
% disp(['goldenSectionSearch1 k: ', num2str(k_goldenSectionSearch1)])
% 
% % Use fminbnd to find the minimum value in the range [k_left, k_right]
% k_optimal = fminbnd(J_squre, k_left, k_right);
% 
% % Display the result of the fminbnd optimization
% disp(['Optimal k: ', num2str(k_optimal)]);

% plot Cost Function
%plotCostFunction(k_span, J_squre);