clear; close all;
%% Initialisation
snrPerBitDb = 0: 1: 20;
snr = 10 .^ (snrPerBitDb / 10);
nSnrs = length(snrPerBitDb);
nTxs = 2;
nRxs = 2;
% rank deficient, one stream only
channelMat = ones(2);
% full rank, multiple eigenmode transmission
% channelMat = sqrt(2) * eye(2);
% channelMat = diag([1 sqrt(2)]);
% channelMat = rand(2);
%% SVD decomposing and multiple / dominant eigenmode transmission 
% channel matrix decomposition
[u, sigma, v] = svd(channelMat);
% unify notation
v = v';
% diagonal entries are eigenvalues
lambda = diag(sigma .^ 2);
% declare power allocation
powerStream = zeros(nSnrs, length(lambda));
% distribute power based on iterative water-filling algorithm
for iSnr = 1: nSnrs
    [powerStream(iSnr, :)] = water_filling(lambda, snr(iSnr));
end
