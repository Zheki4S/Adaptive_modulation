function berShell()
    

    seed = 110;
    rand('state', seed);
    randn('state', seed);
    maxErrors = 1000;
   
    modType = 'QPSK';
    snrArr = -15:1:25;

    berFunc = [];

    
    for snr = snrArr
        errorCurrent = 0;
        trBitsLen = 0;
        berArr = [];
        while errorCurrent <= maxErrors      
            [errBits, allBits] = main(snr, modType);
            errorCurrent = errorCurrent + errBits;
            trBitsLen = trBitsLen + allBits; 
        end    
        f_ber = errorCurrent / trBitsLen;
        berFunc = [berFunc, f_ber];
        
    end
    
   % figure;
    semilogy(snrArr, berFunc, 'LineWidth', 2);
    hold on;
    grid on;
    xlabel('snr, dB'); title('BER');
    legend(modType);


end