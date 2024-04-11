function bits = source(params)
    
    modType = params.modType;
    numBitsPerSymb = params.numBitMap(modType);
    params.tbLength = params.groupLen * numBitsPerSymb;
    

    bits = randn(1, params.tbLength) > 0;
    
end