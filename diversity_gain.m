function [divGain] = diversity_gain(snr, ber)
% Function: 
%   - compute the diversity gain based on BER and SNR
%
% InputArg(s):
%   - snr: analytical signal-to-noise ratio per bit 
%   - ber: bit error rate
%
% OutputArg(s):
%   - divGain: diversity gain
%
% Comments:
%   - The diversity gain is commonly taken as the asymptotic slope, i.e.
%   for SNR approaches infinity
%
% Author & Date: Yang (i@snowztail.com) - 28 Jan 19

divGain = -log2(ber) ./ log2(snr);
end

