clear; close all;
%% Initialisation
snrDb = -10: 1: 20;
snr = 10 .^ (snrDb / 10);
nSnrs = length(snrDb);
nTxs = 2;
nRxs = 2;
% rank deficient, dominant eigenmode transmission
channelDet = ones(2);
% full rank, multiple eigenmode transmission
channelMet = sqrt(2) * eye(2);
% channelMet = randn(2) + 1i * randn(2);
capacityDet = zeros(nSnrs, 1);
capacityMet = zeros(nSnrs, 1);
%% SVD decomposing and multiple / dominant eigenmode transmission 
% channel matrix decomposition
[uDet, sigmaDet, vDet] = svd(channelDet);
[uMet, sigmaMet, vMet] = svd(channelMet);
% unify notation
vDet = vDet';
vMet = vMet';
% diagonal entries are eigenvalues
lambdaDet = diag(sigmaDet .^ 2)';
lambdaMet = diag(sigmaMet .^ 2)';
% declare power allocation
powerDet = zeros(nSnrs, length(lambdaDet));
powerMet = zeros(nSnrs, length(lambdaMet));
% distribute power based on iterative water-filling algorithm
for iSnr = 1: nSnrs
    [powerDet(iSnr, :)] = water_filling(lambdaDet, snr(iSnr));
    [powerMet(iSnr, :)] = water_filling(lambdaMet, snr(iSnr));
    % calculate capacity
    capacityDet(iSnr) = sum(log2(1 + snr(iSnr) * powerDet(iSnr, :) .* lambdaDet));
    capacityMet(iSnr) = sum(log2(1 + snr(iSnr) * powerMet(iSnr, :) .* lambdaMet));
end
figure;
plot(snrDb, capacityDet, 'r-.x');
hold on;
plot(snrDb, capacityMet, 'k-o');
grid on;
legend('2-by-2 rank deficient', '2-by-2 full rank');
xlabel('SNR per bit (dB)');
ylabel('Channel capacity (bps/Hz)');
title('Analytical capacity with CSIT of rank deficient and full rank channels');
