function distortions = InitDistortions(params)
    
   % frequency-selective chanel coef   
    Fs = params.Fs;
    tay = params.tay;
    H = params.H;
    N = length(H);
    len = params.sigLen;

    % Dynamic impulse response
    hk = ray(params);
%     plot(abs(hk(:, 1)));
%     hold on; grid on;
    % Set power profile + normalization
    hk = powerProfileSet(hk, params);
    iRlen = floor(tay(end) * Fs) + 1;
    iRs = zeros(len, iRlen);
    
    for id = 1:N
        iRs(:, floor(tay(id) * Fs) + 1) = hk(:, id);
    end    
    
    % Transformation to gain
    Hfs = zeros(len, iRlen);
    for id = 1:len
       Hfs(id, :) = fft(iRs(id, :)); 
    end
          
    % Phase compensation  
    Hfs = abs(Hfs); 
    % hold on; grid on;
    Hfs = reshape(Hfs, 1, []);
    Hfs = Hfs(1:len);

    % Thermal noise
    Z = randn(1, params.sigLen) + 1i * randn(1, params.sigLen);
    Zfreq = fft(Z);
    Zfreq = Zfreq ./ sqrt(mean(abs(Zfreq).^2));
    alpha = 10^((-params.snr)/20);
    Zfreq = alpha .* Zfreq;
    
    
    distortions.Hfs = Hfs;
    distortions.Zfreq = Zfreq;

    
    % Cheating SNR estimation for adaptive modulation
    HResh = reshape(Hfs, params.groupLen, []);
    HPowerMean = mean(HResh.^2);
    distortions.HPowerMean = HPowerMean;
% 
   % cdfplot(abs(Hfs).^2);
%     cdfplot(HPowerMean);
%     hold on;grid on;
%     hold on; grid on;
%     plot(10*log10(HPowerMean));
end

