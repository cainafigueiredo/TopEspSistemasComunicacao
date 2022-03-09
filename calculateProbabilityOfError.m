function [probabilityOfError] = calculateProbabilityOfError(actual,estimated)
%CALCULATEPROBABILITYOFERROR Summary of this function goes here
%   Detailed explanation goes here
probabilityOfError = actual ~= estimated;
totalElements = size(probabilityOfError,1) * size(probabilityOfError,2);
probabilityOfError = reshape(probabilityOfError, 1, totalElements);
probabilityOfError = sum(probabilityOfError)/totalElements;
end

