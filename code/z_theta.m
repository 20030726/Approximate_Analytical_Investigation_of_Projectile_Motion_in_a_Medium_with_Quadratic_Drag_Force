function z = z_theta(z0, v, v0, theta, theta0, g, beta)
    z = z0 + (v0^2 * sin(theta0)^2 - v^2 * sin(theta)^2) / (g * (2 + beta));
end
