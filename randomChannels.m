% Definindo constantes
L = 41;
M = 8;
epochs = 1;
numberOfRandomChannels = 10000;
noiseVariances = 1:-0.05:0.05;
deltaValues = (L-1)/2:10:L-1;

% Definindo variáveis para posterior plotagem dos gráficos
snr = 1./noiseVariances;
snrdB = convertSNRTodB(snr);

% Abrindo um arquivo de texto para armazenar os resultados
fileID = fopen('resultsRandomChannels.csv','w');

% Escrevendo os nomes das colunas no arquivo de resultados
fprintf(fileID, "%s,%s,%s,%s,%s,%s\n", ["typeOfChannel", "delta", "noiseVariance", "SNR (dB)", "BPSKProbError", "QAM4ProbError"]);

% Gerando os canais e as matrizes de convolução
for noiseVarianceIndex = 1:size(noiseVariances,2)
    %disp(noiseVarianceIndex);
    noiseVariance = noiseVariances(noiseVarianceIndex);
    
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

    probErrorBPSK = zeros(numberOfRandomChannels, size(deltaValues,2));
    probErrorQAM4 = zeros(numberOfRandomChannels, size(deltaValues,2));

    % Gerando os ruídos de forma a obter diferentes valores para o SNR
    for i = 1:numberOfRandomChannels
        disp(i);
        h = randomlyUniformDistributedNormalizedChannel(L);
        H_i = generateChannelMatrix(h, M);
        
        % Obtendo as submatrizes de H_i
        for deltaIndex = 1:size(deltaValues,2)
            delta = deltaValues(deltaIndex);
            H = getChannelSubMatrix(H_i, L, delta);

            % Calculando a matriz K a partir da solução do método de mínimos
            % quadrados
            K_leasSquares = leastSquaresSolution(H);
            
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
            probErrorBPSK(i,deltaIndex) = calculateProbabilityOfError(sBPSK, sBPSKEstimated);
    
            % --- QAM-4
            probErrorQAM4(i,deltaIndex) = calculateProbabilityOfError(sQAM4, sQAM4Estimated);
        end
    end

    meanProbErrorBPSK = mean(probErrorBPSK);
    meanProbErrorQAM4 = mean(probErrorQAM4);

    fprintf(fileID, "randomUniform,");
    fprintf(fileID, "%f ", deltaValues);
    fprintf(fileID, ",%f,", noiseVariance);
    fprintf(fileID, "%f, ", snrdB(noiseVarianceIndex));
    fprintf(fileID, "%f ", meanProbErrorBPSK);
    fprintf(fileID, ",");
    fprintf(fileID, "%f ", meanProbErrorQAM4);
    fprintf(fileID, "\n");
end 

% Fechando o arquivo de texto com os resultados
fclose(fileID);