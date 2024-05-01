function [errBits, allBits, errBlocks, allBlocks, Th] = main(snr, modType, Fd)
    
    % Initialization
    params = InitParams(snr, modType, Fd);
    distortions = InitDistortions(params);
    
    allBits = 0;
    errBits = 0;
    
    allBlocks = 0;
    errBlocks = 0;
    
    Th = 0;
    

    powerThreshList = [0, params.powerThresholdList, 255];
    HPowerMean = distortions.HPowerMean;
    
    for modGroupId = 1:size(params.modTypeList, 2)
        
        params.modType = params.modTypeList(:, modGroupId);
        corr4modIdx = find((HPowerMean < powerThreshList(modGroupId + 1)) & (distortions.HPowerMean >= powerThreshList(modGroupId))) + params.delay;
        corr4modIdx = corr4modIdx(corr4modIdx <= length(HPowerMean));
        if (params.adaptMode && params.modType == params.initialModType)
           corr4modIdx = [1:params.delay, corr4modIdx]; 
        end
        corr4modPwr = HPowerMean(corr4modIdx);
        idx4samples = (corr4modIdx - 1).' * params.groupLen;
        idx4samples = reshape((idx4samples + (0:9)).', 1, []) + 1;
        currHk = distortions.Hk(idx4samples); 
        currZ  = distortions.Z(idx4samples);
        
    
        
        % Generate bit sequence
        txTb = source(params, length(corr4modPwr));
        params.txTb = txTb;
        
        % Mapping
        [modData, params] = mapper(txTb, params);
        
        % Channel
        codedSignal = applyChannel(modData, currHk, currZ);

        % Demapper
        recievedBits = demapper(codedSignal, params); 
        
        % Results
        [errBitsNow, errBlocksNow] = monitorResults(recievedBits, params);
        
        allBlocksNow = length(params.txTb) / params.groupLen / params.numBitsPerSymb;
        
        % BLER
        errBlocks = errBlocks + errBlocksNow;
        allBlocks = allBlocks + allBlocksNow;
        
        % Through pass
        blerNow = errBlocksNow / allBlocksNow;
        ThNow = params.codeRate * params.numBitsPerSymb * (params.groupLen - params.pilotSymbs) * (1 - blerNow) * params.BW ./ params.groupLen;
        Th = Th + allBlocksNow * ThNow;
        
        % BER
        errBits = errBits + errBitsNow;
        allBits = allBits + length(params.txTb);
        
      %  disp([char(params.modType), ': ', num2str(100 * length(corr4modIdx) ./ params.groupsNum), '%']);
        
    end
     
    Th = Th ./ params.groupsNum;
end