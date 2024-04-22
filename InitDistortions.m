function distortions = InitDistortions(params)
       
       
    % Chanel coefs   
    hk = ray(params);
          
    % Phase compensation  
    hk = abs(hk); 
    
    hk = hk ./ sqrt(mean(hk.^2));
%     
%     hold on; grid on;
%     plot(20*log10(hk));
       
    % Thermal noise
    Z = randn(1, params.sigLen) + 1i * randn(1, params.sigLen);
    Z = Z ./ sqrt(mean(abs(Z).^2));
    alpha = 10^((-params.snr)/20);
    Z = alpha .* Z;
    
    
    distortions.Hk = hk;
    distortions.Z = Z;

    
    % Cheating SNR estimation for adaptive modulation
    HResh = reshape(hk, params.groupLen, []);
    HPowerMean = mean(HResh.^2);
    distortions.HPowerMean = HPowerMean;
% 
   % cdfplot(abs(Hfs).^2);
%     cdfplot(HPowerMean);
%     hold on;grid on;
%     hold on; grid on;
%     plot(10*log10(HPowerMean));
end

