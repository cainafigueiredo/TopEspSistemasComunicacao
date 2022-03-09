function [v] = generateBPSKNoise(rows, columns, mean, variance)
%GENERATENOISE Summary of this function goes here
%   Detailed explanation goes here
v = randn(rows,columns)*sqrt(variance) + mean;
end

