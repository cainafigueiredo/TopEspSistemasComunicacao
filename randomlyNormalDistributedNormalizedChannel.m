function [h] = randomlyNormalDistributedNormalizedChannel(L)
%RANDOMLY Summary of this function goes here
%   Detailed explanation goes here
h = randn(1,L);
h = h/norm(h);
end

