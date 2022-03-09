function [s] = bpskNormalizedSignal(M)
%BPSKNORMALIZEDSIGNAL Summary of this function goes here
%   Detailed explanation goes here
possibleValues = [1 -1];
indexChoices = round(rand(M,1)*(length(possibleValues)-1)) + 1;
s = transpose(possibleValues(indexChoices));
end

