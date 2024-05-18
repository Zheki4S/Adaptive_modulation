function [indexes, distortions] = calcIndexes(params, distortions)


 numBitsVec = zeros(1, size(params.modTypeList, 2));
    for modGroupId = 1:size(params.modTypeList, 2)
        numBitsVec(modGroupId) = params.numBitMap(params.modTypeList(:, modGroupId));
    end    

    powerThreshList = [0, params.powerThresholdList, 255];
    HPowerMean = distortions.HPowerMean;
    
    for modGroupId = 1:size(params.modTypeList, 2)
        
        params.modType = params.modTypeList(:, modGroupId);
        corr4modIdxNow = find((HPowerMean < powerThreshList(modGroupId + 1)) & (distortions.HPowerMean >= powerThreshList(modGroupId))) + params.delay;
        corr4modIdxNow = corr4modIdxNow(corr4modIdxNow <= length(HPowerMean));
        if (params.adaptMode && params.modType == params.initialModType)
           corr4modIdxNow = [1:params.delay, corr4modIdxNow]; 
        end
        corr4modPwrNow = HPowerMean(corr4modIdxNow);
        idx4samplesNow = (corr4modIdxNow - 1).' * params.groupLen;
        idx4samplesNow = reshape((idx4samplesNow + (0:9)).', 1, []) + 1;
        currHk = distortions.Hk(idx4samplesNow); 
        currZ  = distortions.Z(idx4samplesNow);
        
       
        indexes.idx4samples{modGroupId, :} = idx4samplesNow; 
        indexes.samplesLoad(idx4samplesNow) = numBitsVec(modGroupId);
        indexes.corr4modPwr{modGroupId, :} = corr4modPwrNow;
        distortions.Hk_grouped{modGroupId, :} = currHk;
        distortions.Z_grouped{modGroupId, :} = currZ;
        
    end
    indexes.numBitsVec = numBitsVec;
    bitsIndexesRow = cumsum(indexes.samplesLoad);
    indexes.tbLen = bitsIndexesRow(end);

    for modGroupId = 1:size(params.modTypeList, 2)
        temp = bitsIndexesRow(indexes.idx4samples{modGroupId});
        indexes.bitsIndexes{modGroupId, :} = reshape(temp - (0:numBitsVec(modGroupId)-1).', 1, []);
    end
    
    max4EveryMod = zeros(1, size(params.modTypeList, 2));
    for id = 1:size(params.modTypeList, 2)
        max4EveryMod(id) = max(indexes.bitsIndexes{id});
    end
    
end

