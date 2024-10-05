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

% Extract the results
ttheta = y(1,:);
vtheta = y(2,:);
xtheta = y(3,:);
ztheta = y(4,:);

% Calculate RMSE
RMSE_t = sqrt(mean((t - ttheta).^2));
RMSE_v = sqrt(mean((v - vtheta).^2));
RMSE_x = sqrt(mean((x - xtheta).^2));
RMSE_z = sqrt(mean((z - ztheta).^2));
RMSE_traj = sqrt(RMSE_x^2 + RMSE_z^2);

% Plotting results
figure;

subplot(3, 1, 1);
plot(theta_span, t, 'b-', 'LineWidth', 2);
hold on;
plot(theta_span, ttheta, 'r--', 'LineWidth', 2);
xlabel('Theta (rad)');
ylabel('Time (s)');
title(['Time over Angle (RMSE: ', num2str(RMSE_t), ')']);
legend('Analytical', 'Numerical', 'Location', 'best');
grid on;
xlim([min(theta_span) max(theta_span)]);
ylim([min(t) max(t)]);

subplot(3, 1, 2);
plot(theta_span, v, 'b-', 'LineWidth', 2);
hold on;
plot(theta_span, vtheta, 'r--', 'LineWidth', 2);
xlabel('Theta (rad)');
ylabel('Velocity (m/s)');
title(['Velocity over Angle (RMSE: ', num2str(RMSE_v), ')']);
legend('Analytical', 'Numerical', 'Location', 'best');
grid on;
xlim([min(theta_span) max(theta_span)]);
ylim([min(v) max(v)]);

subplot(3, 1, 3);
plot(x, z, 'b-', 'LineWidth', 2);
hold on;
plot(xtheta, ztheta, 'r--', 'LineWidth', 2);
xlabel('X Position (m)');
ylabel('Z Position (m)');
title(['Trajectory (RMSE: ', num2str(RMSE_traj), ')']);
legend('Analytical', 'Numerical', 'Location', 'best');
grid on;
xlim([min([x xtheta])*1.1 max([x xtheta])*1.1]);
ylim([min([z ztheta])*1.1 max([z ztheta])*1.1]);


% figure
% plot(k_x, 'r', 'LineWidth', 2,'DisplayName', 'k_x');hold on
% plot(k_z, 'g', 'LineWidth', 2,'DisplayName', 'k_z');
% plot(k_t, 'b', 'LineWidth', 2,'DisplayName', 'k_t');hold off
% legend show;
% xlabel('Iteration');
% ylabel('k Values');
% title('k_x, k_z, k_t over Iterations');
% grid on;
% 
% % 計算k_optimal的平均值
% k_optimal = mean(k_t + k_x + k_z);
% disp('k_optimal');
% disp(num2str(k_optimal));
%     % 計算 kt, kx, kz
%     k_t(i) = (2 * (v(i-1) * sin(theta_span(i-1)) - v(i) * sin(theta_span(i)))) / (g * (t(i) - t(i-1)) - 2) * (1 / (a + b));
% 
%     k_x(i) = (v(i-1)^2 * sin(2 * theta_span(i-1)) - v(i)^2 * sin(2 * theta_span(i))) / (2 * g * (x(i) - x(i-1)) - 1) * (1 / (a + b));
% 
%     k_z(i) = (v(i-1)^2 * sin(2 * theta_span(i-1)^2 - v(i)^2 * sin(2 * theta_span(i))^2) / (g * (z(i) - z(i-1))) - 2) * (1 / (a + b));
% 
%     % break if hit the ground
%     if y(4,i) < 0
%         t = t(1:i);
%         v = v(1:i);
%         x = x(1:i);
%         z = z(1:i);
%         k_t = k_t(1:i);
%         k_x = k_x(1:i);
%         k_z = k_z(1:i);
%         theta_span = theta_span(1:i);
%         y = y(:, 1:i);
%         break;
%     end
