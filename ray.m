function [hArr] = ray(params)

    Ts = 1 / params.chFs;
    N = params.N;
    Fd = params.Fd;
    Fc = params.Fc;
    tay = params.tay;
    delCount = length(params.H);
    L = params.sigLen;
    
    
    n = 1 : N;
    adMtx = hadamard(N);
    teta  = rand(1, N) * 2 * pi;
    h = zeros(L/(params.fourieLength), delCount);
    
    % I
    for id = 1:delCount
       A = adMtx(id, :);
       ctr = 1;
       for l = 1 : L
            h(ctr, id) = sqrt(2 / N) * sum(A .* exp(1i * pi * n / N) .* cos(2 * pi * Fd * Ts * l * cos(2 * pi * (n - 0.5) / 4 /N) + teta));
            ctr = ctr + 1;
       end 
       h(:, id) = h(:, id) .* exp(-1i * 2 * pi * Fc .* tay(id));
    end
    hArr = h;
          
    
end