function [errBits, errBlocks, Th] = monitorResults(recievedBits, params, indexes)


    rxBits = recievedBits;
    txBits = params.txTb;
    
    % BER
    errBits = sum(rxBits ~= txBits);
    
    
    errBlocks = 0;
    Th = 0;
    % BLER & Through pass
    for id = 1:length(indexes.numBitsVec)
        % BLER
        rxReshBitsMod = reshape(rxBits(indexes.bitsIndexes{id}), params.groupLen * indexes.numBitsVec(id), []);
        txReshBitsMod = reshape(txBits(indexes.bitsIndexes{id}), params.groupLen * indexes.numBitsVec(id), []);
        groupErrs = sum(rxReshBitsMod ~= txReshBitsMod);
        errBlocksNow = length(find(groupErrs > params.blockErrAllow));
        errBlocks = errBlocks + errBlocksNow;
        
        % Through pass
        allBlocksNow = size(txReshBitsMod, 2);
        blerNow = errBlocksNow / allBlocksNow;
        ThNow = params.codeRate * indexes.numBitsVec(id) * (params.groupLen - params.pilotSymbs) * (1 - blerNow) * params.BW ./ params.groupLen;
        Th = Th + allBlocksNow * ThNow;
    end
    
    Th = Th ./ params.groupsNum;
    
    
    
end