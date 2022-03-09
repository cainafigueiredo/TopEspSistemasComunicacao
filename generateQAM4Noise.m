function [v] = generateQAM4Noise(rows, columns, mean, variance)
%GENERATENOISE Summary of this function goes here
%   Detailed explanation goes here
individualVariance = variance/2;
realPart = randn(rows,columns)*sqrt(individualVariance) + mean;
imagPart = randn(rows,columns)*sqrt(individualVariance) + mean;
v = realPart + imagPart*i;
end

