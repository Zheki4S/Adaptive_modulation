function animatedFourie(iRs, Fs)

       
       signal = iRs(1, :);
       len = length(signal);
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
       
       pl = plot(f, y, 'm', 'LineWidth', 2);
       grid on;
       strTitle = strcat('|H(f)|');
       title(strTitle);
       xlabel('MHz');
       ylabel('|H(f)| (dB)');
       
       
       
       for id = 1:size(iRs, 1)
          signal = iRs(id, :);
          len = length(signal);
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
          set(pl, 'XData', f, 'YData', y);
          pause(0.04); 
       end    
    

end