function [bitQpsk, snrAvg] = ml_receiver(symbolRx, channel, powerNoise)
% Function: 
%   - maximum-likelihood receiver for spatial multiplexing transmission
%
% InputArg(s):
%   - symbolRx: received symbol stream
%   - channel: channel matrix (channel impulse response)
%   - powerNoise: noise power
%
% OutputArg(s):
%   - bitQpsk: recovered bit stream
%   - snrAvg: average output SNR
%
% Comments:
%   - optimum but inefficient
%   - the complexity grows exponentially with the increase of transmit
%   antennas count since the candidate set expands
%   - parallel symbols are grouped together for detection
%   - [0, 0] -> (1 + 1i); [0, 1] -> (1 - 1i); 
%   - [1, 0] -> (-1 + 1i); [1, 1] -> (-1 - 1i)
%
% Author & Date: Yang (i@snowztail.com) - 13 Feb 19

%% Calculate average SNR
nTxs = size(channel, 2);
nBits = length(symbolRx) * nTxs * 2;
bitQpsk = zeros(1, nBits);
% compute average received bit power
powerBitAvg = norm(symbolRx) ^ 2 / nBits;
% and average output SNR
snrAvg = powerBitAvg / powerNoise;
%% Decode by maximul-likelihood detector
symbolSet = [1 + 1i; 1 - 1i; -1 + 1i; -1 - 1i];
% extend the set
symbolSet = repmat(symbolSet, nTxs, 1);
% obtain all possible groups for given number of transmitters
symbolSet = unique(nchoosek(symbolSet, nTxs), 'rows').';
% obtain the number of symbol groups (parallel symbols)
nGroups = length(symbolRx);
for iGroup = 1: nGroups
    % calculate the shift in signal space group by group
    shift = repmat(symbolRx(:, iGroup), 1, length(symbolSet)) - 1 / nTxs * channel * symbolSet;
    % compute the Euclidean distance to the candidate groups 
    distance = vecnorm(shift);
    % find the closest group and regard as transimitted symbol
    [~, index] = min(distance);
    symbolRx(:, iGroup) = symbolSet(:, index);
end
symbolRx = reshape(symbolRx, 1, length(symbolRx) * nTxs);
% demap to bits
bitQpsk(1: 2: end - 1) = 1 / 2 * (1 - sign(real(symbolRx)));
bitQpsk(2: 2: end) = 1 / 2 * (1 - sign(imag(symbolRx)));
end

