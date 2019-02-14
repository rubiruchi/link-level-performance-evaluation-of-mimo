function [smSymbol] = spatial_multiplexing(symbol, channel)
% Function: 
%   - spatial multiplexing transmission on multiple transmitters
%   - transmit independent data streams on each antenna
%
% InputArg(s):
%   - symbol: symbol to be transmitted on multiple transmit antennas
%   - channel: channel matrix (channel impulse response)
%
% OutputArg(s):
%   - smSymbol: transmit symbols on multiple transmitters 
%
% Comments:
%   - full-rate code (multiplexing gain = number of transmitters)
%   - assume one symbol duration, each codeword is a vector of size (number 
%   of transmitters * 1)
%
% Author & Date: Yang (i@snowztail.com) - 22 Jan 19

nTxs = size(channel, 2);
nSymbols = length(symbol);
% pad zero symbols at the end if the remainder is non-zero
if mod(nSymbols, nTxs)
    symbol(end - (nTxs - mod(nSymbols, nTxs)): end) = 0;
end
smSymbol = 1 / sqrt(nTxs) * reshape(symbol, nTxs, nSymbols / nTxs);
end

