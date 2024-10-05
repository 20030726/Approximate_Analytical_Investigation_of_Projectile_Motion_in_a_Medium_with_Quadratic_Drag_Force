clc
clear
close all
%% Problem
% The large RMS in the k = 0.548 case is due to the function becoming too nonlinear, 
% causing our approximate analytical solution using the trapezoidal method to no longer fit the true trajectory.
%% Solution
% Change the time step to 0.001 radians, and the result will improve.


%%
% Define parameters
global g k
v0 = 50; % Initial velocity 
x0 = 0;
z0 = 0;
t0 = 0; % Initial time 
theta0 = (80)*(pi/180); % Initial angle (rad)
initial_conditions = [t0;v0;x0;z0];
g = 9.81; % Acceleration due to gravity (m/s^2)
k = 0.00548; % Damping coefficient 
step = (-0.001)*(pi/180); % (rad)

% Define the angle range, slightly above -90 degrees
theta_span = theta0 : step : deg2rad(-90+1e-10);

% Preallocate arrays for better performance
t = zeros(1, length(theta_span));
x = zeros(1, length(t));
z = zeros(1, length(t));
v = zeros(1, length(t));
y = zeros(4, length(t));
k_x = zeros(1, length(t)-1);
k_z = zeros(1, length(t)-1);
k_t = zeros(1, length(t)-1);

% Initial conditions
t(1) = t0;
v(1) = v0;
x(1) = x0;
z(1) = z0;
y(:,1) = initial_conditions;


% loop
for i = 2:length(theta_span)

    % v(theta)
    v(i) = v_theta( theta_span(i), theta_span(1), v(1), k);
    % parameters
    a = v(i-1)^2*sin(theta_span(i-1));
    b = v(i).^2*sin(theta_span(i));
    beta = k*(a+b);
    % t(theta)
    t(i) = t_theta(t(i-1), v(i), v(i-1), theta_span(i), theta_span(i-1), g, beta);
    % x(theta)
    x(i) = x_theta(x(i-1), v(i), v(i-1), theta_span(i), theta_span(i-1), g, beta);
    % z(theta)
    z(i) = z_theta(z(i-1), v(i), v(i-1), theta_span(i), theta_span(i-1), g, beta);
    % numerical
    y(:,i) = RK4(@f_theta,theta_span(i-1),y(:,i-1),step);

    % break if hit the ground
    if y(4,i) < 0
        t = t(1:i);
        v = v(1:i);
        x = x(1:i);
        z = z(1:i);
        theta_span = theta_span(1:i);
        y = y(:, 1:i);
        break;
    end
end

% Store x and z into x_data and y_data after the loop
x_data = x;
y_data = z;
save('trajectory_data.mat', 'x_data', 'y_data', 'theta_span');