function dydtheta = f_theta(theta, y)
    % Define global variables
    global g k

    % Extract state variables
    t = y(1);
    v = y(2);
    x = y(3);
    z = y(4);

    % Define differential equations
    dtdtheta = -v / (g * cos(theta));
    dvdtheta = (v * tan(theta) + k * v^3 / cos(theta));
    dxdt = -v^2 / g;
    dzdt = -v^2 * tan(theta) / g;

    % Return derivatives
    dydtheta = [dtdtheta; dvdtheta; dxdt; dzdt];
end