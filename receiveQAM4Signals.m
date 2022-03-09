function [sEstimated] = receiveQAM4Signals(K, y)
%RECEIVEQAM4SIGNALS Summary of this function goes here
%   Detailed explanation goes here
qam4_const = sqrt(2)/2;
sEstimated = K*y;
realPart = sign(real(sEstimated));
imagPart = sign(imag(sEstimated))*1i;
sEstimated = qam4_const*(realPart + imagPart);
end

