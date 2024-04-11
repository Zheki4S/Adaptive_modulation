clear all; close all; clc

snapshots = 100000;
EbNo = 0:15;
M = 2; % modulation order (BPSK)
Mt = 2; % num. of Tx antennas
Mr = [1; 2]; % num. of Rx antennas

ostbcEnc = comm.OSTBCEncoder('NumTransmitAntennas', Mt); % for Alamouti

ric_ber = zeros(length(EbNo), length(M), length(Mr));
sum_BER_alam = zeros(length(EbNo), length(M), length(Mr));
sum_BER_det = zeros(length(EbNo), length(M), length(Mr));

for mr = 1:length(Mr)
    ostbcComb = comm.OSTBCCombiner('NumTransmitAntennas', Mt, 'NumReceiveAntennas', Mr(mr));
    H = zeros(Mr(mr), Mt, snapshots);
    alam_fad_msg = zeros(snapshots, Mr(mr));
        for m = 1:length(M)

            ric_ber(:,m,mr) = berfading(EbNo, 'psk', M(m), Mr(mr)*Mt, 0);

            snr = EbNo+10*log10(log2(M(m))); % Signal-to-Noise Ratio
            message = randi([0, M(m)-1],100000,1);

            mod_msg = pskmod(message, M(m), 0, 'gray');
            Es = mean(abs(mod_msg).^2); % symbol energy

            alam_msg = step(ostbcEnc, mod_msg); % OSTBC encoding

            % Channel
            h = (1/sqrt(2))*(randn(Mr(mr),Mt,snapshots/Mt)...
            + 1j*randn(Mr(mr),Mt, snapshots/Mt)); % Rayleigh flat fading

            % Channel is stable during to time-slots: 
            H(:,:,1:2:end-1) = h;
            H(:,:,2:2:end) = h;

            pathGainself = permute(H,[3,2,1]);

            % Transmit through the channel (Alamouti):
            for q = 1:snapshots;  
                alam_fad_msg(q,:) = (sqrt(Es/Mt)*H(:,:,q)*alam_msg(q,:).').';
            end

            % DET:
            sigmas = zeros(length(mod_msg), 1);
            for hi = 1:length(mod_msg)
                [U, Sigma, Vh] = svd(H(:, :, hi));
                sigmas(hi) = Sigma(1, 1);
            end

            det_fad_msg = mod_msg.*sigmas;

            No = Es./((10.^(EbNo./10))*log2(M(m))); % Noise spectrum density
            for c = 1:500
                for jj = 1:length(EbNo)
                    alam_noisy_msg = alam_fad_msg + ... 
                        sqrt(No(jj)/2)*(randn(size(alam_fad_msg)) + ...
                        1j*randn(size(alam_fad_msg))); % AWGN 
                    alam_decodeData = step(ostbcComb,alam_noisy_msg,pathGainself); %OSTBC combining
                    alam_demod_msg = pskdemod(alam_decodeData, M(m), 0, 'gray'); % demodulation
                    [number,alam_BER(c,jj)] = biterr(message, alam_demod_msg); % BER

                    det_noisy_msg = det_fad_msg+ ... 
                        sqrt(No(jj)/2)*(randn(size(mod_msg)) + ...
                        1j*randn(size(mod_msg))); %AWGN 
                    det_decodeData = det_noisy_msg./sigmas; % Zero-Forcing equalization
                    det_demod_msg = pskdemod(det_decodeData, M(m), 0, 'gray'); % demodulation
                    [number,det_BER(c,jj)] = biterr(message, det_demod_msg); % BER
                end
            end
            sum_BER_alam(:,m, mr) = sum(alam_BER)./c;
            sum_BER_det(:,m, mr) = sum(det_BER)./c;
        end
end

figure(1)

semilogy(EbNo, sum_BER_alam(:, 1, 1), 'b-o', ...
         EbNo, sum_BER_det(:,1,1), 'b->',...
         EbNo, ric_ber(:,1,1), 'b-',...
         EbNo, sum_BER_alam(:, 1, 2), 'r-o', ...
         EbNo, sum_BER_det(:,1,2), 'r->',...
         EbNo, ric_ber(:,1,2), 'r-',...
         'LineWidth', 1.5)
title('BPSK (Rayleigh flat fading)')
legend('Alamouti (2x1)','Tx-MRC (2x1)','2-nd order diversity', ...
        'Alamouti (2x2)','DET (2x2)','4-th order diversity')
xlabel('EbNo (dB)') 
ylabel('BER') 
grid on