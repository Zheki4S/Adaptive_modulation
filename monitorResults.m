function [errBits, errBlocks] = monitorResults(recievedBits, params)


    rxBits = recievedBits;
    txBits = params.txTb;
    
    rxResh = reshape(rxBits, params.groupLen * params.numBitsPerSymb, []);
    txResh = reshape(txBits ,params.groupLen * params.numBitsPerSymb, []);
    
    groupErrs = sum(rxResh ~= txResh);
    errBlocks = length(find(groupErrs > params.blockErrAllow));
    
    %ber = sum(rxBits ~= txBits) ./ length(txBits);
    errBits = sum(rxBits ~= txBits);
    %disp(ber);

end