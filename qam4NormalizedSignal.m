function [s] = qam4NormalizedSignal(M)
%QAM4NORMALIZEDSIGNAL Summary of this function goes here
%   Detailed explanation goes here
qam4_const = sqrt(2)/2;
possibleValues = [qam4_const*(1 + j) qam4_const*(1 - j) qam4_const*(-1 + j) qam4_const*(-1 - j)];
indexChoices = round(rand(M,1)*(length(possibleValues)-1)) + 1;
s = transpose(possibleValues(indexChoices));
end

