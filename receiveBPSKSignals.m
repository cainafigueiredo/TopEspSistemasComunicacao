function [sEstimated] = receiveBPSKSignals(K,y)
%RECEIVEBPSKSIGNALS Summary of this function goes here
%   Detailed explanation goes here
sEstimated = K*y;
sEstimated = sign(sEstimated);
end

