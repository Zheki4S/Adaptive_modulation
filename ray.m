function h = ray(params)

    Ts = 1 / params.chFs;
    N = params.N;
    Fd = params.Fd;
    L = params.sigLen;
    
    
    n = 1 : N;
    adMtx = hadamard(N);
    teta  = rand(1, N) * 2 * pi;
    h = zeros(1, L);
    
    A = adMtx(ceil(16*rand(1)), :);
    for l = 1 : L
        h(l) = sqrt(2 / N) * sum(A .* exp(1i * pi * n / N) .* cos(2 * pi * Fd * Ts * l * cos(2 * pi * (n - 0.5) / 4 /N) + teta));
    end       
end