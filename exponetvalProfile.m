function exponentialProfile()

    tay_max = 3;% mcs
    tay_max = tay_max / 10^6;
    
    tay_slope = 1/7 * tay_max;
    
    
    %t = linspace(0,tay_max, 1000);
    
    %prof = exp(-t/tay_slope);
    
    %time_moments = [0, sort(rand(1,5) * tay_max)];
    
    %tMcsec = time_moments * 10^6;
    
    %prof = exp(-time_moments / tay_slope);
    %prof = 10 * log10(prof);
    
    time_moments = [0, 0.6232, 0.6915, 0.9037, 1.4128, 2.5329];

    time_moments = time_moments; % convert to sec
    prof = [0, -6.3155, -7.007, -9.1581, -14.3164, -25.6675];
    
    hold on; grid on;
    stem(time_moments, prof, 'BaseValue', -30, 'Color', 'Blue');
    title('Спектр мощности задержек сигнала');
    xlabel('мкс');
    ylabel('дБ');

end