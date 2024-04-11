function mQAM_theor()
    
    col = "red"
    snrArr = -15:100;
    M = 16; % for modylations with even powers of two i.e QAM-4, QAM-16, QAM-64, QAM-256
    lg2M = log(sqrt(M))/log(2);
    gamma = 10.^(snrArr./10);
    errOnSymb = 1;
    BER = errOnSymb/lg2M  * (1 - 1 / sqrt(M)) .* erfc((sqrt(1.5 .* gamma ./ (M - 1))));     
    
    figure;
    semilogy(snrArr, BER, 'Marker', 'v', 'Color', col, 'MarkerEdgeColor', col, 'MarkerFaceColor', col);
    hold on;
    grid on;
    %legend('512QAM');

end

