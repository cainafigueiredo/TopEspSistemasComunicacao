function [H] = generateChannelMatrix(h, M)
%GENERATECHANNELMATRIX Summary of this function goes here
%   Detailed explanation goes here
H_firstRow = [h(end) zeros(1,M-1)];
H_firstColumn = [flip(transpose(h)); zeros(M-1,1)];
H = toeplitz(H_firstColumn, H_firstRow);
end

