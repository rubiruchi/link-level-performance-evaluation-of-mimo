function [symbolQpsk] = qpsk(bitStream, powerBit)
% Function: 
%   - map bit stream to uncoded QPSK symbols
%
% InputArg(s):
%   - bitStream: bit stream in 0 and 1
%   - powerBit: average bit power
%
% OutputArg(s):
%   - symbolQpsk: uncoded QPSK symbols
%
% Restraints:
%   - plain output symbol without error detection and correction coding
%
% Comments:
%   - signal space is 2-D
%   - assume initial phase is pi / 4 (symbols on the diagonal of quadrants)
%   - [0, 0] -> [sqrt(p / 2), sqrt(p / 2)]
%   - [0, 1] -> [sqrt(p / 2), -sqrt(p / 2)]
%   - [1, 0] -> [-sqrt(p / 2), sqrt(p / 2)]
%   - [1, 1] -> [-sqrt(p / 2), -sqrt(p / 2)]
%
% Author & Date: Yang (i@snowztail.com) - 21 Jan 19

nBits = length(bitStream);
nSymbols = nBits / 2;
bitPairs = zeros(2, nSymbols);
bitPairs(1, :) = bitStream(1: 2: end - 1);
bitPairs(2, :) = bitStream(2: 2: end);
bitPairs = 1 - 2 * bitPairs;
symbolQpsk = sqrt(powerBit) * (bitPairs(1, :) + 1i * bitPairs(2, :));
end

