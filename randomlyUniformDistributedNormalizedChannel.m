function [h] = randomlyUniformDistributedNormalizedChannel(L)
%RANDOMLY Summary of this function goes here
%   Detailed explanation goes here
h = rand(1,L);
h = h/norm(h);
end

