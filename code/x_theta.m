function x = x_theta(x0, v, v0, theta, theta0, g, beta)
    x = x0 + (v0^2 * sin(2 * theta0) - v^2 * sin(2 * theta)) / (2 * g * (1 + beta));
end
