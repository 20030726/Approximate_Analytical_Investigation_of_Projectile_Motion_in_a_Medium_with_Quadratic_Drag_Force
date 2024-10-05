function v = v_theta( theta, theta0, v0, k)
    f = (sin(theta) ./ cos(theta).^2) + log(tan(theta / 2 + pi / 4));
    f0 = (sin(theta0) ./ cos(theta0).^2) + log(tan(theta0 / 2 + pi / 4));
    v = (v0 * cos(theta0)) ./ (cos(theta) .* sqrt(1 + k * v0^2 * cos(theta0)^2 .* (f0 - f)));
end

