function fourie(signal, Fs)
        
    len = 1024;
    Ynew = fft(signal, len);
    signalFFT = fftshift(Ynew);
    spectrumPlotArray = abs(signalFFT).^2;
    
    
    specLen = len;
    NFFT = len;
    specParts = reshape(spectrumPlotArray(1:specLen * floor(NFFT / specLen)), [], specLen);
    specParts = mean(specParts, 1);
    
    f = (Fs * 1e-6) * linspace(-0.5, 0.5, specLen);
    specParts = specParts ./ max(specParts);
    y = 10 * log10(specParts);
    
    
    plot(f, y, 'LineWidth', 2);
    strTitle = strcat('|H(f)|');
    title(strTitle);
    xlabel('MHz');
    ylabel('|H(f)| (dB)');
    
    
    


end