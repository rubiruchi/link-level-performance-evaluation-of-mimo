clear; close all;
%% Initialisation
snrDb = -10: 1: 20;
snr = 10 .^ (snrDb / 10);
nSnrs = length(snrDb);
% MIMO channels: Rx-by-Tx: 2-by-2, 2-by-4, 4-by-2
nRxs = [2 2 4];
nTxs = [2 4 2];
nStreams = min(nTxs, nRxs);
% number of MIMO scenarios 
nCases = length(nTxs);
% generate numerous channels for ergodity
nChannels = 1e4;
capacityCdit = zeros(nCases, nSnrs);
capacityCsit = zeros(nCases, nSnrs);
for iCase = 1: nCases
    for iSnr = 1: nSnrs
        powerCdit = zeros(nChannels, nStreams(iCase));
        powerCsit = zeros(nChannels, nStreams(iCase));
        lambda = zeros(nChannels, nStreams(iCase));
        for iChannel = 1: nChannels
            % i.i.d. CSCG channel
            channel = sqrt(1 / 2) * (randn(nTxs(iCase), nRxs(iCase)) + 1i * randn(nTxs(iCase), nRxs(iCase)));
            % channel matrix decomposition
            [u, sigma, v] = svd(channel);
            % unify notation
            v = v';
            % diagonal entries are eigenvalues
            lambda(iChannel, :) = diag(sigma .^ 2)';
            % the ergodic capacity with CDIT is acheived by equal power allocation
            powerCdit(iChannel, :) = 1 / nTxs(iCase);
            % the ergodic capacity with CSIT is acheived by water-filling algorithm
            powerCsit(iChannel, :) = water_filling(lambda(iChannel, :), snr(iSnr));
        end
        % calculate capacity
        capacityCdit(iCase, iSnr) = sum(mean(log2(1 + snr(iSnr) * powerCdit .* lambda)));
        capacityCsit(iCase, iSnr) = sum(mean(log2(1 + snr(iSnr) * powerCsit .* lambda)));
    end
end
figure;
plot(snrDb, capacityCdit(1, :), 'k--o');
hold on;
plot(snrDb, capacityCsit(1, :), 'k-o');
hold on;
plot(snrDb, capacityCdit(2, :), 'b--s');
hold on;
plot(snrDb, capacityCsit(2, :), 'b-s');
hold on;
plot(snrDb, capacityCdit(3, :), 'r--x');
hold on;
plot(snrDb, capacityCsit(3, :), 'r-x');
grid on;
legend('2-by-2 (CDIT)', '2-by-2 (CSIT)', '2-by-4 (CDIT)', '2-by-4 (CSIT)', '4-by-2 (CDIT)', '4-by-2 (CSIT)', 'location', 'northwest');
xlabel('SNR per bit (dB)');
ylabel('Ergodic capacity (bps/Hz)');
ylim([0 16]);
title('Ergodic capacity of various MIMO (Rx-by-Tx) channels with CDIT and CSIT');
