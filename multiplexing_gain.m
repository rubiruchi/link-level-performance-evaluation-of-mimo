function [mulGain] = multiplexing_gain(capacitySiso, capacityMimo)
% Function: 
%   - compute the multiplexing gain of MIMO system
%
% InputArg(s):
%   - capacitySiso: capacity (transmission rate) of SISO system
%   - capacityMimo: capacity (transmission rate) of MIMO system
%
% OutputArg(s):
%   - mulGain: multiplexing gain
%
% Comments:
%   - measure the number of independent streams that can be transmitted in
%   parallel in the MIMO channel
%   - is the pre-log factor of the rate at high SNR
%   - is commonly taken as the asymptotic slope, i.e. for SNR approaches 
%   infinity
%
% Author & Date: Yang (i@snowztail.com) - 14 Feb 19

mulGain = capacityMimo ./ capacitySiso;
end

