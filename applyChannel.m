function sigOut = applyChannel(sigIn, params, distortions, group_id)

        Hfs = distortions.Hfs((params.groupLen * (group_id - 1) + 1) : params.groupLen * group_id);
        Zfreq = distortions.Zfreq((params.groupLen * (group_id - 1) + 1) : params.groupLen * group_id);
        sigOut = (Hfs .* sigIn + Zfreq) ./ Hfs;
        
end

