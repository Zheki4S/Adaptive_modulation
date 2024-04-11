function [errBits, ber] = monitorResults(recievedBits, params)


    rxBits = recievedBits;
    txBits = params.txTb;
    
    ber = sum(rxBits ~= txBits) ./ length(txBits);
    errBits = sum(rxBits ~= txBits);
    %disp(ber);

end