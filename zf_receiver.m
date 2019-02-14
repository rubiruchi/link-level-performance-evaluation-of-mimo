function [bitRec, snrAvg] = zf_receiver(symbolRx, channel, powerNoise)
% Function: 
%   - zero-forcing receiver for spatial multiplexing transmission
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
%   - suboptimum but efficient
%   - decouple the channel into nTxs parallel channels -> suppressed
%   interference, scalar decoding on each channel
%   - the inversion step enhances the noise (especially at low SNR)
%   - low complexity comes with the limitation of a diversity gain (nRxs - 
%   nTxs + 1)
%   - the system is undetermined if nRxs > nTxs.
%
% Author & Date: Yang (i@snowztail.com) - 14 Feb 19

%% Calculate average SNR
nTxs = size(channel, 2);
nBits = length(symbolRx) * nTxs * 2;
bitRec = zeros(1, nBits);
% compute average received bit power
powerBitAvg = norm(symbolRx) ^ 2 / nBits;
% and average output SNR
snrAvg = powerBitAvg / powerNoise;
%% Decode by zero-forcing detector
% zero-forcing filter
zfFilter = sqrt(nTxs) * pinv(channel);
% filter output is the transmitted symbol vector plus enhanced noise
symbolOut = zfFilter * symbolRx;
% reshape to stream
symbolOut = reshape(symbolOut, 1, length(symbolOut) * nTxs);
% demap to bits
bitRec(1: 2: end - 1) = 1 / 2 * (1 - sign(real(symbolOut)));
bitRec(2: 2: end) = 1 / 2 * (1 - sign(imag(symbolOut)));
end

