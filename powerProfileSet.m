function hk = powerProfileSet(hk, params)
        H = params.H;
        N = length(H);

        hk = hk ./ sqrt(mean(abs(hk).^2));
        
        for id = 1:N
            hk(:, id) = hk(:, id) .* (H(id)); 
        end

        coef = mean(sum(abs(hk.').^2));
        
        hk = hk ./ sqrt(coef);   
        
end