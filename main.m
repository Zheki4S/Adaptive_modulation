function [errBits, allBits] = main(snr, modType)
    
    % Initialization
    params = InitParams(snr, modType);
    distortions = InitDistortions(params);
    
    allBits = 0;
    errBits = 0;
    bpskCtr = 0;
    qpskCtr = 0;
    psk8Ctr = 0;
    
    th1 = params.powerThresholdList(1);
    th2 = params.powerThresholdList(2);
    
    for group_id = 1 : params.groupsNum
        % Generate bit sequence
        txTb = source(params);
        params.txTb = txTb;
        
        % Mapping
        [modData, params] = mapper(txTb, params);

        % Channel
        codedSignal = applyChannel(modData, params, distortions, group_id);

        
        % Demapper
        recievedBits = demapper(codedSignal, params);  
        
        % Modtype switch
        estSnr = distortions.HPowerMean(group_id);
%        disp(params.modType);
        if(params.adaptMode)
            if(estSnr < th1)
                params.modType = 'BPSK';
                bpskCtr = bpskCtr + 1;
            end

            if(estSnr >= th1 && (estSnr < th2))
                params.modType = 'QPSK';  
                qpskCtr = qpskCtr + 1;
            end

            if(estSnr >= th2)
                params.modType = '8PSK';
                psk8Ctr = psk8Ctr + 1;
            end

        end
        
        % Results
        [errBitsNow, ber] = monitorResults(recievedBits, params);
        errBits = errBits + errBitsNow;
        allBits = allBits + length(params.txTb);
    
    end
    
%             
%     disp(["BPSK: ", num2str(100 * bpskCtr ./ params.groupsNum), "%"]);
%     disp(["QPSK: ", num2str(100 * qpskCtr ./ params.groupsNum), "%"]);
%     disp(["8PSK: ", num2str(100 * psk8Ctr ./ params.groupsNum), "%"]);
end