function bits = demapper(codedSignal, params)

    symbSet = params.symbSet;
    bitSet = params.bitSet;

    llr = MaxLogMapDemapper(codedSignal, symbSet.', bitSet(:, 1:params.numBitsPerSymb), 1);
    llr = flipud(llr);
    bits = ((sign(llr) + 1) / 2);
    bits = reshape(bits, 1, []);

 
end