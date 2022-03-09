function [snrdB] = convertSNRTodB(snr)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
snrdB = 10*log10(snr);
end