





% BPSK
snrArr = -15:1:24;
p0 = 10.^(snrArr./10); 
BER = 0.5*(1 - sqrt((p0./(p0 + 1))));

col = "blue";
figure;
semilogy(snrArr, BER, 'Marker', 'v', 'Color', col, 'MarkerEdgeColor', col, 'MarkerFaceColor', col);
hold on;
grid on;
xlabel("SNR, dB");
ylabel("BER");

% QPSK
snrArr = -15:1:28;
p0 = 10.^(snrArr./10);
BER = 0.5*(1 - sqrt(((0.5 * p0)./(0.5 * p0 + 1))));

col = "red";
semilogy(snrArr, BER, 'Marker', 'v', 'Color', col, 'MarkerEdgeColor', col, 'MarkerFaceColor', col);


%8PSK
snrArr = -15:1:32;
p0 = 10.^(snrArr./10);
BER = 0.5*(1 - sqrt(((1/5 * p0)./(1/5 * p0 + 1))));

col = "green";
semilogy(snrArr, BER, 'Marker', 'v', 'Color', col, 'MarkerEdgeColor', col, 'MarkerFaceColor', col);

%16QAM
snrArr = -15:1:34;
p0 = 10.^(snrArr./10);
BER = 3/4 .* func(1/5 .* p0) + 1/2 .* func(9/5 .* p0) - 1/4 .* func(5 .* p0);

col = "black";
semilogy(snrArr, BER, 'Marker', 'v', 'Color', col, 'MarkerEdgeColor', col, 'MarkerFaceColor', col);


%64QAM
snrArr = -15:1:40;
p0 = 10.^(snrArr./10);
BER = 7/12 .* func(1/21 .* p0) + 1/2 .* func(3/7 .* p0) - 1/12 .* func(21/21 .* p0) + 1/12 .* func(81/21 .* p0) - 1/12 .* func(13/12 .* p0);
  
col = "green";
semilogy(snrArr, BER, 'Marker', 'v', 'Color', col, 'MarkerEdgeColor', col, 'MarkerFaceColor', col);
legend('BPSK', 'QPSK', '8PSK', '16QAM', '64QAM');
