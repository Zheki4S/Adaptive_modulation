function relay_th_theor(modType)

groupLenSymb = 10;
groupErrAllowed = 1;
BW = 500e3;
pilotSymbs = 0;
codeRate = 1;

switch modType
 case 'BPSK'
        numBitsPerSymb = 1;
        groupLen = groupLenSymb * numBitsPerSymb;
        snrArr = -15:1:24;
        p0 = 10.^(snrArr./10); 
        BER = 0.5*(1 - sqrt((p0./(p0 + 1))));
        for id = 0:groupErrAllowed
           C(id + 1) = nchoosek(groupLen, id);
        end
        blockOk = C .* BER.'.^(0:groupErrAllowed) .* (1 - BER.').^(groupLen:-1:(groupLen - groupErrAllowed));
        blockOk = [blockOk, zeros(1,length(BER)).'];
        blockOk = sum(blockOk.');
        BLER = 1 - blockOk;
        Th = codeRate .* numBitsPerSymb .* (groupLen - pilotSymbs*numBitsPerSymb) .* (1 - BLER) .* BW ./ groupLen;
        col = "red";
        plot(snrArr, Th, 'Marker', 'v', 'Color', col, 'MarkerEdgeColor', col, 'MarkerFaceColor', col);
        hold on; grid on;

case 'QPSK'
        numBitsPerSymb = 2;
        groupLen = groupLenSymb * numBitsPerSymb;
        snrArr = -15:1:28;
        p0 = 10.^(snrArr./10);
        BER = 0.5*(1 - sqrt(((0.5 * p0)./(0.5 * p0 + 1))));

        for id = 0:groupErrAllowed
           C(id + 1) = nchoosek(groupLen, id);
        end
        blockOk = C .* BER.'.^(0:groupErrAllowed) .* (1 - BER.').^(groupLen:-1:(groupLen - groupErrAllowed));
        blockOk = [blockOk, zeros(1,length(BER)).'];
        blockOk = sum(blockOk.');
        BLER = 1 - blockOk;
        Th = codeRate .* numBitsPerSymb .* (groupLen - pilotSymbs*numBitsPerSymb) .* (1 - BLER) .* BW ./ groupLen;
        col = "blue";
        plot(snrArr, Th, 'Marker', 'v', 'Color', col, 'MarkerEdgeColor', col, 'MarkerFaceColor', col);
        hold on; grid on;

case '8PSK' 
        numBitsPerSymb = 3;
        groupLen = groupLenSymb * numBitsPerSymb;
        snrArr = -15:1:30;
        p0 = 10.^(snrArr./10);
        BER = 0.5*(1 - sqrt(((1/4 * p0)./(1/4 * p0 + 1))));
        for id = 0:groupErrAllowed
           C(id + 1) = nchoosek(groupLen, id);
        end
        blockOk = C .* BER.'.^(0:groupErrAllowed) .* (1 - BER.').^(groupLen:-1:(groupLen - groupErrAllowed));
        blockOk = [blockOk, zeros(1,length(BER)).'];
        blockOk = sum(blockOk.');
        BLER = 1 - blockOk;
        Th = codeRate .* numBitsPerSymb .* (groupLen - pilotSymbs*numBitsPerSymb) .* (1 - BLER) .* BW ./ groupLen;
        col = "green";
        plot(snrArr, Th, 'Marker', 'v', 'Color', col, 'MarkerEdgeColor', col, 'MarkerFaceColor', col);
        hold on; grid on;
case 'QAM16'
        numBitsPerSymb = 4;
        groupLen = groupLenSymb * numBitsPerSymb;
        snrArr = -15:1:34;
        p0 = 10.^(snrArr./10);
        BER = 3/4 .* func(1/5 .* p0) + 1/2 .* func(9/5 .* p0) - 1/4 .* func(5 .* p0);
        for id = 0:groupErrAllowed
           C(id + 1) = nchoosek(groupLen, id);
        end
        blockOk = C .* BER.'.^(0:groupErrAllowed) .* (1 - BER.').^(groupLen:-1:(groupLen - groupErrAllowed));
        blockOk = [blockOk, zeros(1,length(BER)).'];
        blockOk = sum(blockOk.');
        BLER = 1 - blockOk;
        Th = codeRate .* numBitsPerSymb .* (groupLen - pilotSymbs*numBitsPerSymb) .* (1 - BLER) .* BW ./ groupLen;
        col = "black";
        plot(snrArr, Th, 'Marker', 'v', 'Color', col, 'MarkerEdgeColor', col, 'MarkerFaceColor', col);
        hold on; grid on;

case 'QAM64'
    numBitsPerSymb = 6;
    groupLen = groupLenSymb * numBitsPerSymb;
    snrArr = -15:1:40;
    p0 = 10.^(snrArr./10);
    BER = 7/12 .* func(1/21 .* p0) + 1/2 .* func(3/7 .* p0) - 1/12 .* func(21/21 .* p0) + 1/12 .* func(81/21 .* p0) - 1/12 .* func(13/12 .* p0);
    for id = 0:groupErrAllowed
           C(id + 1) = nchoosek(groupLen, id);
    end
    blockOk = C .* BER.'.^(0:groupErrAllowed) .* (1 - BER.').^(groupLen:-1:(groupLen - groupErrAllowed));
    blockOk = [blockOk, zeros(1,length(BER)).'];
    blockOk = sum(blockOk.');
    BLER = 1 - blockOk;
    Th = codeRate .* numBitsPerSymb .* (groupLen - pilotSymbs*numBitsPerSymb) .* (1 - BLER) .* BW ./ groupLen;
    col = "green";
    plot(snrArr, Th, 'Marker', 'v', 'Color', col, 'MarkerEdgeColor', col, 'MarkerFaceColor', col);
    hold on; grid on;

end   

end