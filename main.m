function [errBits, allBits, errBlocks, allBlocks, Th] = main(snr, modType, Fd)
    
    % Initialization
    params = InitParams(snr, modType, Fd);
    distortions = InitDistortions(params);
    
    [indexes, distortions] = calcIndexes(params, distortions);
    
    
    % Generate bit sequence
    txTb = source(indexes.tbLen);
    params.txTb = txTb;
    recievedBits = zeros(1, indexes.tbLen);
    
    % Interleaving
    ilBlockSize = params.IlRowNum * params.IlColNum;
    ilCutPoint = floor(indexes.tbLen / ilBlockSize) * ilBlockSize;
    for id = 1:ilCutPoint/ilBlockSize
       temp = txTb((id - 1) * ilBlockSize + 1 : id * ilBlockSize);
       block = reshape(temp, params.IlColNum, params.IlRowNum);
       temp = reshape(block', [], 1);
       txTb((id - 1) * ilBlockSize + 1 : id * ilBlockSize) = temp;  
    end
    indexes.ilCutPoint = ilCutPoint;
    
    % Temperary solve
    shuffInd = randperm(ilCutPoint);
    txTb(1:ilCutPoint) = txTb(shuffInd);
    
    for modGroupId = 1:size(params.modTypeList, 2)
        
        params.modType = params.modTypeList(:, modGroupId);
        
        % Mapping
        [modData, params] = mapper(txTb(indexes.bitsIndexes{modGroupId}), params);
        
        % Channel
        codedSignal = applyChannel(modData, distortions.Hk_grouped{modGroupId}, distortions.Z_grouped{modGroupId});

        % Demapper
        recievedBits(indexes.bitsIndexes{modGroupId}) = demapper(codedSignal, params); 
             
    end
    
    % Recovery
    [~, recInd] = sort(shuffInd);
    recievedBits(1:ilCutPoint) = recievedBits(recInd);
    
    % Deinterleaving
    for id = 1:ilCutPoint/ilBlockSize
       temp = recievedBits((id - 1) * ilBlockSize + 1 : id * ilBlockSize);
       block = reshape(temp, params.IlRowNum, params.IlColNum);
       temp = reshape(block', [], 1);
       recievedBits((id - 1) * ilBlockSize + 1 : id * ilBlockSize) = temp;    
    end
    
    % Results
    [errBits, errBlocks, allBits, allBlocks, Th] = monitorResults(recievedBits, params, indexes);
        
    
end