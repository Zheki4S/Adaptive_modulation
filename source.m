function bits = source(params, corrGroupsNum)
    
    modType = params.modType;
    numBitsPerSymb = params.numBitMap(modType);
    params.tbLength = params.groupLen * corrGroupsNum * numBitsPerSymb;
    

    bits = randn(1, params.tbLength) > 0;
    
end