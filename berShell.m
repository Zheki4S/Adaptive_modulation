function berShell(modType, Fd, measType)
    

    seed = 110;
    rand('state', seed);
    randn('state', seed);
    maxErrors = 10000;
    
    switch Fd
        case 1
            maxErrors = 300000;
        case 10
            maxErrors = 30000;
        case 60
            maxErrors = 10000;
    end       
    snrArr = -15:1:25;
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
    blerFunc = [];
    thFunc = [];

    
    for snr = snrArr
        
        errorCurrent = 0;
        errBlocksCurrent = 0;
        iterCtr = 0;
        ThCurrent = 0;
        trBitsLen = 0;
        trBlocksLen = 0;
        
        while errorCurrent <= maxErrors      
            [errBits, allBits, errBlocks, allBlocks, Th] = main(snr, modType, Fd);
            
            % BLER
            errBlocksCurrent = errBlocksCurrent + errBlocks;
            trBlocksLen = trBlocksLen + allBlocks;
            
            % Through pass
            ThCurrent = ThCurrent + Th;
            iterCtr = iterCtr + 1;
            
            % BER
            errorCurrent = errorCurrent + errBits;
            trBitsLen = trBitsLen + allBits; 
        end    
        f_ber = errorCurrent / trBitsLen;
        berFunc = [berFunc, f_ber];
        
        f_bler = errBlocksCurrent / trBlocksLen;
        blerFunc = [blerFunc, f_bler];
        
        f_th = ThCurrent / iterCtr;
        thFunc = [thFunc, f_th];
        
    end
    
    switch measType
        case "BER"
             semilogy(snrArr, berFunc, 'LineWidth', 2);
             hold on;
             grid on;
             xlabel('snr, dB'); title('BER');
        case "BLER"
             semilogy(snrArr, blerFunc, 'LineWidth', 2);
             hold on;
             grid on;
             xlabel('snr, dB'); title('BLER');
        case "Th"    
             plot(snrArr, thFunc, 'LineWidth', 2);
             hold on;
             grid on;
             xlabel('snr, dB'); title('Through pass');
    end    
    
   % figure;
%     semilogy(snrArr, berFunc, 'LineWidth', 2);
%     hold on;
%     grid on;
%     xlabel('snr, dB'); title('BER');
 %   legend([modType, ' | Fd = ', num2str(Fd), 'Hz']);


end