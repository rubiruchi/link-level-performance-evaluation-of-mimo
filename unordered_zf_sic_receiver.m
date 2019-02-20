function [bitRec, snrAvg] = unordered_zf_sic_receiver(symbolRx, channel, powerNoise)
% Function: 
%   - unordered successive interference canceller zero-forcing receiver for
%   spatial multiplexing transmission
%
% InputArg(s):
%   - symbolRx: received symbol stream
%   - channel: channel matrix (channel impulse response)
%   - powerNoise: noise power
%
% OutputArg(s):
%   - bitRec: recovered bit stream
%   - snrAvg: average output SNR
%
% Comments:
%   - the error propagation caused by decoding sequence leads to larger BER
%   than ordered (SINR-based)
%   - the error performance is mostly dominated by the weakest stream
%
% Author & Date: Yang (i@snowztail.com) - 17 Feb 19

%% Calculate average SNR
powerSymbol = 1;
nTxs = size(channel, 2);
nBits = length(symbolRx) * nTxs * 2;
bitRec = zeros(1, nBits);
% compute average received bit power
powerBitAvg = norm(symbolRx) ^ 2 / nBits;
% and average output SNR
snrAvg = powerBitAvg / powerNoise;
%% Decode in random sequence
% Initialisation
symbolOut = zeros(size(symbolRx));
% zero-forcing filter
zfFilter = sqrt(nTxs) * pinv(channel);
% ZF decoding for all but the last
for iTx = 1: nTxs - 1
    % extract a stream from the received signal
    symbolOut(iTx, :) = zfFilter(iTx, :) * symbolRx;
    % slice the stream to obtain the estimated transmitted symbol
    symbolOut(iTx, :) = 1 / sqrt(2) * (sign(real(symbolOut(iTx, :))) + 1i * sign(imag(symbolOut(iTx, :))));
    % reduce the influence of the decoded stream
    symbolRx = symbolRx - sqrt(powerSymbol / nTxs) * channel(:, iTx) * symbolOut(iTx, :);
end
% MRC for the last
symbolOut(end, :) = mrc(symbolRx, channel(:, end));
symbolOut(end, :) = 1 / sqrt(2) * (sign(real(symbolOut(end, :))) + 1i * sign(imag(symbolOut(end, :))));
% reshape to stream
symbolOut = reshape(symbolOut, 1, length(symbolOut) * nTxs);
% demap to bits
bitRec(1: 2: end - 1) = 1 / 2 * (1 - sign(real(symbolOut)));
bitRec(2: 2: end) = 1 / 2 * (1 - sign(imag(symbolOut)));
end

