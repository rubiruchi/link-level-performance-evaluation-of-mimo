function [powerStream] = water_filling(lambda, snr)
% Function: 
%   - iterative stream power allocation based on water-filling algorithm
%
% InputArg(s):
%   - lambda: eigenvalues of the channel matrix corresponding to valid
%   non-zero eigenvectors
%   - snr: signal-to-noise ratio per bit
%
% OutputArg(s):
%   - powerStream: power allocated to each stream
%
% Restraints:
%   - this function is based on iterative method which can be inefficient 
%   when numerous streams exist
%
% Comments:
%   - assume power budget is unit
%   - non-zero eigenvalues correspond to feasible eigenvectors and streams
%   - favour multiple eigenmode transmission for high snr and dominant 
%   eigenmode transmission for low snr
%
% Author & Date: Yang (i@snowztail.com) - 11 Feb 19


% initialise power allocation
powerStreamTemp = zeros(1, length(lambda));
% obtain number of available streams
nStreams = length(lambda(abs(lambda) > eps));
% sort in descending order for water filling
[lambda, index] = sort(lambda, 'descend');
% calculate the stream base level (status)
baseLvl = 1 ./ (snr * lambda);
% begin iteration
for iStream = 1: nStreams
    % update quasi water level
    waterLvl = 1 / (nStreams - iStream + 1) * (1 + sum(baseLvl(1: (nStreams - iStream + 1))));
    % try to allocate power with this new water level
    powerStreamTemp(1: iStream) = waterLvl - baseLvl(1: iStream);
    % negative allocation is invalid
    isInvalid = ~all(powerStreamTemp >= 0);
    if isInvalid 
        % invalid power distribution, return the latest valid solution
        break;
    else
        % update power allocation
        powerStream = powerStreamTemp;
    end
end
% sort to ensure power corresponds to correct eigenvalues
powerStream = powerStream(index);
% normalise power
powerStream = powerStream ./ sum(powerStream);
end

