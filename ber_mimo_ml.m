clear; close all;
%% Initialisation
% SNR per bit (Eb/N0)
snrDb = 0: 1: 20;
snr = 10 .^ (snrDb / 10);
nSnrs = length(snrDb);
nTxs = 2;
nRxs = 2;
nChannels = 1e3;
nBits = 1e5;
nSymbols = nBits / 2;
% assume unit symbol power
powerSymbol = 1;
powerBit = powerSymbol / 2;
anaBer = zeros(nSnrs, 1);
numBer = zeros(nSnrs, 1);
snrAvg = zeros(nSnrs, 1);
%% Bit generation, symbol mapping, channel generation, SM transmittion, ML estimation, and BER calculation
% generate raw bit stream
bitStream = round(rand(1, nBits));
% map bits to symbols
symbol = qpsk(bitStream, powerBit);
for iSnr = 1: nSnrs
    % calculate noise power by SNR per bit
    powerNoise = powerBit / snr(iSnr);
    % reset error count
    errorCount = 0;
    % SNR of received signal in a particular channel
    snrChannel = zeros(nChannels, 1);
    for iChannel = 1: nChannels
        % i.i.d. CSCG channel
        channel = sqrt(1 / 2) * (randn(nRxs, nTxs) + 1i * randn(nRxs, nTxs));
        % spatial multiplexing transmission
        [smSymbolTx] = spatial_multiplexing(symbol, channel);
        % generate CSCG noise for each receiver (coef to ensure SNR)
        noise = sqrt(nTxs) * sqrt(powerNoise / 2) * (randn(size(smSymbolTx)) + 1i * randn(size(smSymbolTx)));
        % received signal
        smSymbolRx = channel * smSymbolTx + noise;
        % decode by maximum-likelihood estimation
        [bitRec, snrChannel(iChannel)] = ml_receiver(smSymbolRx, channel, powerNoise);
        % count errors
        errorCount = errorCount + sum(xor(bitStream, bitRec));
    end
    % compute average SNR and BER
    snrAvg(iSnr) = mean(snrChannel);
    numBer(iSnr) = errorCount / nChannels / nBits;
    % analytical BER (approximated)
    dMin = sqrt(2);
    anaBer(iSnr) = (snr(iSnr) / 4 / nTxs) ^ (-nRxs) * (nTxs * dMin ^ 2) ^ (-nRxs);
end
arrayGain = array_gain(snr, snrAvg');
divGain = diversity_gain(snr, numBer');
%% Result plots
% BER comparison
figure(1);
semilogy(snrDb, anaBer, 'k-o');
hold on;
semilogy(snrDb, numBer, 'r-.x');
grid on;
legend('Analytical', 'Numerical');
title('BER vs SNR of spatial multiplexing with ML receiver and QPSK constellation over a 2-by-2 MIMO Rayleigh fading channel');
xlabel('SNR (dB)');
ylabel('BER');
% array and diversity gains
figure(2);
plot(snrDb, arrayGain, 'k-o');
hold on;
plot(snrDb, divGain, 'r-.x');
grid on;
legend('Array gain', 'Diversity gain');
title('Array and diversity gains of spatial multiplexing transmission with ML receiver');
xlabel('SNR (dB)');
ylabel('Gain');
% save data
% numBerMl = numBer;
% save('ber_set.mat', 'numBerMl', '-append');
