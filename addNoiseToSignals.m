function [sNoise] = addNoiseToSignals(s, noiseVariance)
%ADDNOISETOSIGNALS Summary of this function goes here
% Detailed explanation goes here
rows = size(s,1);
columns = size(s,2);
% Gerando ruído para sinais BPSK
if sum(imag(s)) == 0
    noise = generateBPSKNoise(rows, columns, 0, noiseVariance);
% Gerando ruído para sinais QAM-4
else
    noise = generateQAM4Noise(rows, columns, 0, noiseVariance);
end
sNoise = s + noise;
end

