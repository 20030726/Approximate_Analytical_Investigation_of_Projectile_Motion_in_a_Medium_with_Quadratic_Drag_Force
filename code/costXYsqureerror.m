function J_squre = costXYsqureerror(x_data, y_data, theta_span, v0, x0, y0, g, k)
    % Preallocate arrays for the estimated x and y positions
    x_est = zeros(1, length(theta_span));
    y_est = zeros(1, length(theta_span));
    
    % Initial conditions
    x_est(1) = x0;
    y_est(1) = y0;
    v(1) = v0; % Initial velocity

    for i = 2:length(theta_span)
        % v(theta)
        v(i) = v_theta(theta_span(i), theta_span(1), v(1), k);

        % Parameters for beta
        a = v(i-1)^2 * sin(theta_span(i-1));
        b = v(i)^2 * sin(theta_span(i));
        beta = k * (a + b);

        % Estimate x and y positions
        x_est(i) = x_theta(x_est(i-1), v(i), v(i-1), theta_span(i), theta_span(i-1), g, beta);
        y_est(i) = z_theta(y_est(i-1), v(i), v(i-1), theta_span(i), theta_span(i-1), g, beta);
    end
    
    % Compute the cost function based on the difference between estimated and true data
    costX = x_est - x_data;
    costY = y_est - y_data;
    
    % Compute the total cost as the sum of squared errors
    J_squre = costX * costX' + costY * costY';
end
