function [errBits, allBits, errBlocks, allBlocks, Th] = main(snr, modType, Fd)
    
    % Initialization
    params = InitParams(snr, modType, Fd);
    distortions = InitDistortions(params);
    
    [indexes, distortions] = calcIndexes(params, distortions);
    
    
    % Generate bit sequence
    txTb = source(indexes.tbLen);
    params.txTb = txTb;
    recievedBits = zeros(1, indexes.tbLen);
    
   
    for modGroupId = 1:size(params.modTypeList, 2)
        
        params.modType = params.modTypeList(:, modGroupId);
        
        % Mapping
        [modData, params] = mapper(txTb(indexes.bitsIndexes{modGroupId}), params);
        
        % Channel
        codedSignal = applyChannel(modData, distortions.Hk_grouped{modGroupId}, distortions.Z_grouped{modGroupId});

        % Demapper
        recievedBits(indexes.bitsIndexes{modGroupId}) = demapper(codedSignal, params); 
             
    end
    
    % Results
    [errBits, errBlocks, Th] = monitorResults(recievedBits, params, indexes);
        
    allBlocks = params.groupsNum;
    allBits = indexes.tbLen;
    
end