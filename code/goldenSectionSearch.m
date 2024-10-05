function [k,i] = goldenSectionSearch(a, b, J, tol, maxiter)
i=0;
    % Golden ratio
    gr = (sqrt(5) - 1) / 2;

    % Initialize internal points
    x1 = a+gr*(b-a);
    x2 = b-gr*(b-a);
    
    % Calculate objective function values at internal points
    J_x1 = J(x1);
    J_x2 = J(x2);
    
    % Start iteration
    while b-a > tol || i>maxiter
        i = i+1;
        if J_x1 < J_x2
            a = x2;  % Shrink the left boundary
            x2 = x1;
            J_x2 = J_x1;
            x1 = a+gr*(b-a);
            J_x1 = J(x1);
        else
            b = x1;   % Shrink the right boundary
            x1 = x2;
            J_x1 = J_x2;
            x2 = b-gr*(b-a);
            J_x2 = J(x2);
        end
    end

    % Return the midpoint of the interval as the optimal solution
    k = (a + b) / 2;
end
