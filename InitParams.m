function params = InitParams(snr, modType)
    
    params.chFs = 50e4; % Only for chanel coefs
    params.Fs = 50e6; % Sampling frequency
    params.Fc = 11e9; % Carrier frequency
    params.N = 16; % Number of reflectors in a quater
    params.Fd = 10; % max dopler offset 
    
    params.groupLen = 10; % Samples in group for adaptive modulation alghoritm
    params.groupsNum = 10000; % Number of groups
    params.sigLen = params.groupLen * params.groupsNum; % Samples in simulation
    
    params.snr = snr; % dB
    
    
    % Power delay profile
    tay = [0, 0.6232, 0.6915, 0.9037, 1.4128, 2.5329];
    %tay = [0, 0.31, 0.71, 1.09, 1.73, 2.51]; % mcs
    tay = tay .* 10^-6; % convert to sec
    H = [0, -6.3155, -7.007, -9.1581, -14.3164, -25.6675];
    %H = [0, -1, -9, -10, -15, -20]; % dB
    H = 10.^(H /20); % convert amplitude & make linear
    params.tay = tay;
    params.H = H;
    

    params.fourieLength = 100;
    params.chFs = params.chFs / params.fourieLength;
    

    % Modulation type: BPSK, QPSK, 8PSK, QAM16 or Adaptive
    initialModType = 'BPSK';
  %  params.powerThresholdList = [0.515, 1.16]; % Dopler - 1Hz
%     params.powerThresholdList = [0.499, 1.28]; % Dopler - 10Hz
    params.powerThresholdList = [0.714, 1.137]; % Dopler - 60Hz
    
    if(strcmp(modType, 'Adapt'))
        params.modType = initialModType;
        params.adaptMode = true;
    else
        params.modType = modType;
        params.adaptMode = false;
    end
    
    load('mapper_data.mat');
    modTypes = {'BPSK', 'QPSK', '8PSK', 'QAM16', 'QAM64'};
    
    bitSets = {mapper_data.bpsk.bits, mapper_data.qpsk.bits, ...
               mapper_data.psk8.bits, mapper_data.qam16.bits, ...
               mapper_data.qam64.bits};
    
    symbSets = {mapper_data.bpsk.symb, mapper_data.qpsk.symb, ...
                mapper_data.psk8.symb, mapper_data.qam16.symb, ...
                mapper_data.qam64.symb};
          
    numBitsSets = {size(mapper_data.bpsk.bits, 2), size(mapper_data.qpsk.bits, 2), ...
                   size(mapper_data.psk8.bits, 2), size(mapper_data.qam16.bits, 2), ...
                   size(mapper_data.qam64.bits, 2)};       
    
    clear mapper_data;
    
    params.bitSetMap = containers.Map(modTypes, bitSets);
    params.symbSetMap = containers.Map(modTypes, symbSets);
    params.numBitMap = containers.Map(modTypes, numBitsSets);

end