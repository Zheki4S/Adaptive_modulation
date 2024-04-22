function sigOut = applyChannel(sigIn, params, distortions, group_id)

        Hk = distortions.Hk((params.groupLen * (group_id - 1) + 1) : params.groupLen * group_id);
        Z = distortions.Z((params.groupLen * (group_id - 1) + 1) : params.groupLen * group_id);
        sigOut = (Hk .* sigIn + Z) ./ Hk;
        
end

