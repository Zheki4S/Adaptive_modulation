function [errBits, errBlocks, allBits, allBlocks, Th] = monitorResults(recievedBits, params, indexes)


    rxBits = recievedBits;
    txBits = params.txTb;
    
    % BER
    errBits = sum(rxBits(1:indexes.ilCutPoint) ~= txBits(1:indexes.ilCutPoint));   
    errBlocks = 0;
    allBlocks = 0;
    
    Th = 0;
    % BLER & Through pass
    for id = 1:length(indexes.numBitsVec)
        % BLER
        ilCutTailIndexes = indexes.bitsIndexes{id};
        ilCutTailIndexes = ilCutTailIndexes(ilCutTailIndexes <= indexes.ilCutPoint);
        cutLen = floor(length(ilCutTailIndexes)/ params.groupLen / indexes.numBitsVec(id)) * params.groupLen * indexes.numBitsVec(id);
        ilCutTailIndexes = ilCutTailIndexes(1:cutLen);
        
        rxReshBitsMod = reshape(rxBits(ilCutTailIndexes), params.groupLen * indexes.numBitsVec(id), []);
        txReshBitsMod = reshape(txBits(ilCutTailIndexes), params.groupLen * indexes.numBitsVec(id), []);
        
        groupErrs = sum(rxReshBitsMod ~= txReshBitsMod);
%         histogram(groupErrs(groupErrs > 0));
%         hold on; grid on;
        errBlocksNow = length(find(groupErrs > params.blockErrAllow));
        errBlocks = errBlocks + errBlocksNow;
        allBlocksNow = size(txReshBitsMod, 2);
        allBlocks = allBlocks + allBlocksNow;
        
        % Through pass
        blerNow = errBlocksNow / allBlocksNow;
        ThNow = params.codeRate * indexes.numBitsVec(id) * (params.groupLen - params.pilotSymbs) * (1 - blerNow) * params.BW ./ params.groupLen;
        Th = Th + allBlocksNow * ThNow;
        
    end
    
    Th = Th ./ params.groupsNum;
    allBits = indexes.ilCutPoint;
    
    
end