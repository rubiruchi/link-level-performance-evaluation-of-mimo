function [mrcSymbol] = mrc(rxSymbol, gain)
% Function: 
%   - maximal ratio combining on multiple receivers
%
% InputArg(s):
%   - rxSymbol: received symbols on multiple receive antennas
%   - gain: corresponding fading coefficient (channel impulse response)
%
% OutputArg(s):
%   - mrcSymbol: estimated symbol based on channel diversity
%
% Comments:
%   - fixed capacity, enhanced BER
%
% Author & Date: Yang (i@snowztail.com) - 22 Jan 19

mrcSymbol = gain' * rxSymbol / norm(gain);
end

