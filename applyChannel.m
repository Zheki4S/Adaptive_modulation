function sigOut = applyChannel(sigIn, Hk, Z)

        sigOut = (Hk .* sigIn + Z) ./ Hk;
        
end

