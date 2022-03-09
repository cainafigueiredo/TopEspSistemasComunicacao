function [h] = exponentialDistributedNormalizedChannel(L, lambda, moreEnergyToOldestSignals)
%EXPONENTIALDISTRIBUTEDNORMALIZEDCHANNEL Summary of this function goes here
%   Detailed explanation goes here

h = 0:(L-1);
h = lambda*exp(-lambda*h);
h = h/norm(h);
if (moreEnergyToOldestSignals == true)
    h = flip(h);
end
end

