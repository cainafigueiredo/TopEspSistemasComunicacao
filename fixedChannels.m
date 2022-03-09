% Definindo constantes
L = 41;
M = 8;
epochs = 1000;
noiseVariances = 1:-0.0025:0.0025;
deltaValues = (L-1)/2:10:L-1;

% Definindo variáveis para posterior plotagem dos gráficos
snr = 1./noiseVariances;
snrdB = convertSNRTodB(snr);

% Abrindo um arquivo de texto para armazenar os resultados
fileID = fopen('resultsFixedChannels.csv','w');

% Escrevendo os nomes das colunas no arquivo de resultados
fprintf(fileID, "%s,%s,%s,%s,%s,%s,%s\n", ["typeOfChannel", "delta", "channelCoefficients", "noiseVariance", "SNR (dB)", "BPSKProbError", "QAM4ProbError"]);

% Gerando os canais

% --- Canais fixos
% ------ Igualmente distribuído
h_equallyDistributed = equallyDistributedNormalizedChannel(L);

% ------ Exponencialmente distribuído
% ---------- Energia concentrada nos sinais mais recentes
lambda = 0.2;
moreEnergyToOldestSignals = false;
h_exponentialDistributedRecentSignals = exponentialDistributedNormalizedChannel(L, lambda, moreEnergyToOldestSignals);

% ---------- Energia concentrada nos sinais mais antigos
lambda = 0.2;
moreEnergyToOldestSignals = true;
h_exponentialDistributedOldestSignals = exponentialDistributedNormalizedChannel(L, lambda, moreEnergyToOldestSignals);

% --- Canais fixos combinados em um array de canais
h = [h_equallyDistributed; h_exponentialDistributedRecentSignals; h_exponentialDistributedOldestSignals];
hNames = ["h(i) = h(j)", "h(i) > h(j) if i > j", "h(i) < h(j) if i < j"];

% Gerando a matriz de convolução
for i = 1:size(h,1)
    h_i = h(i, 1:size(h,2));
    hName = hNames(i);

    H_i = generateChannelMatrix(h_i, M);

    % Gerando as submatrizes
    for deltaIndex = 1:size(deltaValues,2)
        delta = deltaValues(deltaIndex);
        disp(delta)
        H = getChannelSubMatrix(H_i, L, delta);

        % Calculando a matriz K a partir da solução do método de mínimos
        % quadrados
        K_leasSquares = leastSquaresSolution(H);
    
        % Gerando os sinais BPSK
        sBPSK = zeros(M,epochs);
        for j = 1:epochs
            sBPSK(:,j) = bpskNormalizedSignal(M);
        end
    
        % Gerando os sinais QAM-
        sQAM4 = zeros(M,epochs);
        for j = 1:epochs
            sQAM4(:,j) = qam4NormalizedSignal(M);
        end
    
        % Gerando os ruídos de forma a obter diferentes valores para o SNR
        for noiseVarianceIndex = 1:size(noiseVariances,2)
            noiseVariance = noiseVariances(noiseVarianceIndex);
            
            % Transmitindo os sinais BPSK através do canal
            zBPSK = transmitSignals(H,sBPSK);
    
            % Transmitindo os sinais BPSK através do canal
            zQAM4 = transmitSignals(H,sQAM4);
    
            % Adicionando os ruídos aos sinais BPSK transmitidos
            yBPSK = addNoiseToSignals(zBPSK, noiseVariance);
    
            % Adicionando os ruídos aos sinais QAM-4 transmitidos
            yQAM4 = addNoiseToSignals(zQAM4, noiseVariance);
    
            % Estimando os sinais utilizando a solução do método de mínimos
            % quadrados
            % --- Estimando os sinais BPSK recebidos
            sBPSKEstimated = receiveBPSKSignals(K_leasSquares, yBPSK);
    
            % --- Estimando os sinais QAM-4 recebidos
            sQAM4Estimated = receiveQAM4Signals(K_leasSquares, yQAM4);
    
            % Calculando a taxa de erro
            % --- BPSK
            probErrorsBPSK = calculateProbabilityOfError(sBPSK, sBPSKEstimated);
    
            % --- QAM-4
            probErrorsQAM4 = calculateProbabilityOfError(sQAM4, sQAM4Estimated);
    
            fprintf(fileID, "%s,", hName);
            fprintf(fileID, "%f,", delta);
            fprintf(fileID, "%f ", h_i);
            fprintf(fileID, ",%f,", noiseVariance);
            fprintf(fileID, "%f, ", snrdB(noiseVarianceIndex));
            fprintf(fileID, "%f,", probErrorsBPSK);
            fprintf(fileID, "%f", probErrorsQAM4);
            fprintf(fileID, "\n");
        end
    end
end 

% Fechando o arquivo de texto com os resultados
fclose(fileID);