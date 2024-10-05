function t = t_theta(t0, v, v0, theta, theta0, g, beta)
    t = t0 + 2 * (v0 * sin(theta0) - v * sin(theta)) / (g * (2 + beta));
end