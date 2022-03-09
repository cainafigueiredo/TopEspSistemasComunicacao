function [H_submatrix] = getChannelSubMatrix(H, L, delta)
%GETCHANNELSUBMATRIX Summary of this function goes here
%   Detailed explanation goes here
P = size(H,1);
[top down] = deal(L-delta, P-L+delta+1);
H_submatrix =  H(top:down, :); 
end

