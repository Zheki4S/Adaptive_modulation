function berShell()
    

    seed = 110;
    rand('state', seed);
    randn('state', seed);
    maxErrors = 10000;
   
    modType = 'Adapt';
    snrArr = -15:1:20;
    switch modType
        case 'BPSK'
            snrArr = -15:1:24;
        case 'QPSK'
            snrArr = -15:1:28;
        case '8PSK'
            snrArr = -15:1:30;
        case 'QAM16'
            snrArr = -15:1:34;
        case 'QAM64'
            snrArr = -15:1:40;    
    end   

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