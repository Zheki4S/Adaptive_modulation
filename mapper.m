function [modData, params] = mapper(txTb, params)
    
    modType = params.modType;
    
    bits = params.bitSetMap(modType);
    symb = params.symbSetMap(modType);
    numBitsPerSymb = params.numBitMap(modType);

    
    txTb = reshape(txTb, numBitsPerSymb, []);
    address = ones([1, size(txTb, 2)]);
    
    for indx = 1 : size(txTb, 2)
       bitsColumn = txTb(:, indx);
       address(indx) = address(indx) + sum(2.^(find(bitsColumn) - 1)); 
    end    
       
    modData = symb(address).';
    
    params.sigLen = length(modData);
    params.bitSet = bits;
    params.symbSet = symb;
    params.numBitsPerSymb = numBitsPerSymb;
    
end