% snrArr = [5:2:21];
% cmp4_1Hz =  [8.5e-2, 4.9e-2, 2.5e-2, 1.2e-2, 6.2e-3, 3.8e-3, 2.4e-3, 1.6e-3, 9e-4];
% cmp4_10Hz = [8.7e-2, 5.1e-2, 2.7e-2, 1.4e-2, 6.9e-3, 4.1e-3, 2.6e-3, 1.7e-3, 9.3e-4];
% cmp4_60Hz = [9.1e-2, 6e-2, 3.5e-2, 1.8e-2, 9.5e-3, 5.1e-3, 3e-3, 1.8e-3, 9.4e-4];
% 
% figure;
% semilogy(snrArr, cmp4_1Hz, 'LineWidth', 2);  
% hold on;
% grid on; 
% semilogy(snrArr, cmp4_10Hz, 'LineWidth', 2);   
% semilogy(snrArr, cmp4_60Hz, 'LineWidth', 2);   
% xlabel('snr, dB'); title('BER');


berShell('QAM16', 60);
berShell('Adapt', 1);
berShell('Adapt', 10);
berShell('Adapt', 60);

% legend('Cmp: Adapt | Fd = 1Hz', 'Cmp: Adapt | Fd = 10Hz', 'Cmp: Adapt | Fd = 60Hz', ...
%        'QPSK', 'Adapt | Fd = 1Hz', 'Adapt | Fd = 10Hz', 'Adapt | Fd = 60Hz');
legend('QPSK', 'Adapt | Fd = 1Hz', 'Adapt | Fd = 10Hz', 'Adapt | Fd = 60Hz');