function params = InitParams(snr, modType)
    
    params.chFs = 7500; % Only for chanel coefs
    params.Fs = 50e6; % Sampling frequency
    params.Fc = 11e9; % Carrier frequency
    params.N = 16; % Number of reflectors in a quater
    params.Fd = 1; % max dopler offset 
    
    params.groupLen = 10; % Samples in group for adaptive modulation alghoritm
    params.groupsNum = 10000; % Number of groups
    params.sigLen = params.groupLen * params.groupsNum; % Samples in simulation
    params.snr = snr; % dB
    
    
    % Modulation type: BPSK, QPSK, 8PSK, QAM16 or Adaptive
    initialModType = 'BPSK';
    
    switch params.Fd
        case 1
          params.powerThresholdList = [0.4211, 1.1075]; % Dopler - 1Hz
        case 10  
          params.powerThresholdList = [0.4183, 1.1026]; % Dopler - 10Hz
        case 60  
          params.powerThresholdList = [0.4298, 1.1014]; % Dopler - 60Hz
    end
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