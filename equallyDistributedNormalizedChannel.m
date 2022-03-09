function [h] = equallyDistributedNormalizedChannel(L)
%EQUALLYDISTRIBUTEDNORMALIZEDCHANNEL Summary of this function goes here
%   Detailed explanation goes here
h = ones(1,L);
h = h/norm(h);
end