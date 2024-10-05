function plotCostFunction(k_span, J_squre)

    % 初始化一個陣列來儲存每個 k 對應的 J_squre 值
    J_squre_values = zeros(size(k_span));

    % 計算每個 k 對應的 J_squre 值
    for i = 1:length(k_span)
        k = k_span(i);
        J_squre_values(i) = J_squre(k);  
    end

    % 繪製 J_squre(k) 隨 k 的變化圖
    figure;
    plot(k_span, J_squre_values, 'b-', 'LineWidth', 2); 

    % 標記 x 和 y 軸
    xlabel('k');
    ylabel('Cost Function Value');

    % 使用 LaTeX 語法添加圖標題
    title('Cost Function $J_{\mathrm{square}}(k)$', 'Interpreter', 'latex');

    % 添加圖例，使用 LaTeX 語法
    legend('$J_{\mathrm{square}}(k)$', 'Interpreter', 'latex');

    % 顯示網格線
    grid on;

end
