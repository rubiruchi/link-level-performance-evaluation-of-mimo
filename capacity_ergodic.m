clear; close all;
%% Initialisation
snrDb = -10: 1: 20;
snr = 10 .^ (snrDb / 10);
nSnrs = length(snrDb);
nTxs = 2;
% nTxs = [2 4 2];
nRxs = 2;
% nRxs = [2 2 4];
nChannels = 1e4;
capacityCdit = zeros(nSnrs, 1);
capacityCsit = zeros(nSnrs, 1);
for iSnr = 1: nSnrs
    powerCdit = zeros(nChannels, nTxs);
    powerCsit = zeros(nChannels, nTxs);
    lambda = zeros(nChannels, nTxs);
    for iChannel = 1: nChannels
        % i.i.d. CSCG channel
        channel = randn(nTxs, nRxs) + 1i * randn(nTxs, nRxs);
        % channel matrix decomposition
        [u, sigma, v] = svd(channel);
        % unify notation
        v = v';
        % diagonal entries are eigenvalues
        lambda(iChannel, :) = diag(sigma .^ 2)';
        % the ergodic capacity with CDIT is acheived by equal power allocation
        powerCdit(iChannel, :) = 1 / nTxs;
        % the ergodic capacity with CSIT is acheived by water-filling algorithm
        powerCsit(iChannel, :) = water_filling(lambda(iChannel, :), snr(iSnr));
    end
    % calculate capacity
    capacityCdit(iSnr) = sum(mean(log2(1 + snr(iSnr) * powerCdit .* lambda)));
    capacityCsit(iSnr) = sum(mean(log2(1 + snr(iSnr) * powerCsit .* lambda)));
%     powerCdit = mean(powerCdit);
%     powerCsit = mean(powerCsit);
end
figure;
plot(snrDb, capacityCdit, 'k-.x');
hold on;
plot(snrDb, capacityCsit, 'k-o');
grid on;
legend('2-by-2 (CDIT)', '2-by-2 (CSIT)');
xlabel('SNR per bit (dB)');
ylabel('Ergodic capacity (bps/Hz)');
title('Ergodic capacity of various MIMO channels with CSIT and CDIT');
