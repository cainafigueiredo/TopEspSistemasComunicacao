function [K] = leastSquares(H)
%LEASTSQUARES Summary of this function goes here
%   Detailed explanation goes here
H_conj = transpose(conj(H));
K = inv(H_conj*H)*H_conj;
end

