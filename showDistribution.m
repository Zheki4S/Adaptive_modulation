function showDistribution(sequence)
    
    dS = 0.01;
    scale = min(sequence):dS:max(sequence);
    distr = zeros(1, length(scale));
    id = 1;
    for x = scale(1:end-1)
        distr(id) = length(find(sequence > x & sequence <= x + dS));
        id = id + 1;
    end    
    
    hold on;
    grid on;
    plot(scale, distr, 'LineWidth', 2);

end