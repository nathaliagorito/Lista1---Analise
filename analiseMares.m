clear; close all; clc;

load dadosCananeia1988.dtf;
baseCananeia = dadosCananeia1988;

load dadosUbatuba1988.dat;
baseUbatuba = dadosUbatuba1988;

calculaDados(baseCananeia);
calculaDados(baseUbatuba);

function calculaDados(arquivoDados)
    baseDados = inputname(1); quantidadeDados = size(arquivoDados, 1);
    tempo = arquivoDados(:, 1); ano = arquivoDados(:, 2); mes = arquivoDados(:, 3); dia = arquivoDados(:, 4); hora = arquivoDados(:, 5); nivelMar = arquivoDados(:, 6) - mean(arquivoDados(:, 6)); qualidade = arquivoDados(:, 7);
    desvioNivelMar = std(nivelMar); mediaNivelMar = mean(nivelMar);
    tempoDias = quantidadeDados / 3600 / 24;
    corLinha = {'r--', 'g--', 'm--', 'b--'};

    %QUESTÃO 1%
    estatisticaBasica = [skewness(nivelMar); kurtosis(nivelMar); desvioNivelMar; max(nivelMar); min(nivelMar); mediaNivelMar; median(nivelMar); mode(nivelMar)];
    
%     linhas = {'Assimetria', 'Curtose', 'Desvio Padrão', 'Máximo', 'Mínimo', 'Média', 'Mediana', 'Moda'};
%     tabelaEstatistica = array2table(estatisticaBasica, 'VariableNames', {'Nivel do Mar'}, 'RowNames', linhas);
%     disp(tabelaEstatistica);

    texto = {
        sprintf('Assimetria: %.4f', estatisticaBasica(1)),
        sprintf('Curtose: %.4f', estatisticaBasica(2)),
        sprintf('Desvio Padrão: %.4f', estatisticaBasica(3)),
        sprintf('Máximo: %.4f', estatisticaBasica(4)),
        sprintf('Mínimo: %.4f', estatisticaBasica(5)),
        sprintf('Média: %.4f', estatisticaBasica(6)),
        sprintf('Mediana: %.4f', estatisticaBasica(7)),
        sprintf('Moda: %.4f', estatisticaBasica(8))
    };
    
    criaGraficoTexto(sprintf('Questão 1: Estatística Básica da Série - %s', baseDados), texto);

    %QUESTÃO 2%
%     figure;
%     graficoValorDesvio = plot(tempoDias, nivelMar, 'b');
%     adicionaLinha('y', mediaNivelMar, 'k-', 'Média', 'left', 'bottom');
%     
%     for i = 1:3
%         adicionaLinha('y', mediaNivelMar + i*desvioNivelMar, corLinha{i}, sprintf('+%dσ', i), 'left', 'middle');
%         adicionaLinha('y', mediaNivelMar - i*desvioNivelMar, corLinha{i}, sprintf('-%dσ', i), 'left', 'middle');
%     end
%     
%     configuraGrafico(graficoValorDesvio, sprintf('Questão 2: Valor Médio e Desvio Padrão - %s', baseDados), 'Tempo (dias)', 'Nível do Mar (m)', {'Nível do Mar', 'Média', '+1σ', '-1σ', '+2σ', '-2σ', '+3σ', '-3σ'});
%     
%     coeficienteTendencia = polyfit(tempoDias, nivelMar, 1);
%     tendencia = polyval(coeficienteTendencia, tempoDias);
%     taxaVariacao = coeficienteTendencia(1);
% 
%     figure;
%     graficoNivelMar = plot(tempoDias, nivelMar, 'b');
%     hold on;
%     graficoTendencia = plot(tempoDias, tendencia, 'r');
%     adicionaLinha('y', taxaVariacao, 'k--', ['Taxa de Variação: ', num2str(taxaVariacao, '%.4f'), 'M/Dia'], 'left', 'bottom');
%     configuraGrafico(graficoNivelMar, sprintf('Questão 2: Valor Médio e Desvio Padrão - %s', baseDados), 'Tempo (dias)', 'Nível do Mar (m)', {'Nível do Mar', 'Tendência', 'Variação'});

    %QUESTÃO 3%
    percentuais = [10 25 75 90];
    percentis = prctile(nivelMar, percentuais);

    figure;
    histogramaNivelMar = histogram(nivelMar);
    
    frequenciaMaxima = max(histogramaNivelMar.Values);
    hold on;
    
    for i = 1:length(percentuais)
        adicionaLinha('x', percentis(i), corLinha{i}, sprintf('P%d: %.2f', percentuais(i), percentis(i)), 'right', 'top');
    end
    
    configuraGrafico(histogramaNivelMar, sprintf('Questão 3: Histograma do Nível do Mar - %s', baseDados), 'Nível do Mar (m)', 'Frequência', {'Nível do Mar', 'Percentis'})

    %QUESTÃO 4%
    betaGumbel = sqrt(6)*desvioNivelMar/pi;
    muGumbel = mediaNivelMar - 0.5772 * betaGumbel;
    
    incremento = input('Insira o incremento: ');
    
    minNivelMar = mediaNivelMar - 4*desvioNivelMar; maxNivelMar = mediaNivelMar + 4*desvioNivelMar;
    nivel = minNivelMar:incremento:maxNivelMar;
    fdpNormal = exp(-(((nivel - mediaNivelMar) / desvioNivelMar).^2) / 2) / (desvioNivelMar * sqrt(2*pi));
    z = (nivel - muGumbel) / betaGumbel;
    fdpGumbel = (1/betaGumbel) * exp(-(z + exp(-z)));
    
    figure
    graficoFdpNormal = plot(nivel, fdpNormal, 'b-')
    hold on
    graficoFdpGumbel = plot(nivel, fdpGumbel, 'g--')
    configuraGrafico(graficoFdpNormal, sprintf('Questão 4: Função Densidade de Probabilidade - %s', baseDados), 'Nível do Mar (m)', 'FDP', {'Normal', 'Valor Extremo (Gumbel)'});
    
    p1Normal = normcdf(50, mediaNivelMar, desvioNivelMar);
    p2Normal = normcdf(55, mediaNivelMar, desvioNivelMar) - normcdf(45, mediaNivelMar, desvioNivelMar);
    p3Normal = 1 - normcdf(60, mediaNivelMar, desvioNivelMar);
    p1Gumbel = exp(-exp(-(50 - muGumbel)/betaGumbel));
    p2Gumbel = exp(-exp(-(55 - muGumbel)/betaGumbel)) - exp(-exp(-(45 - muGumbel)/betaGumbel));
    p3Gumbel = 1 - exp(-exp(-(60 - muGumbel)/betaGumbel));
    
    texto = {
        sprintf('Probabilidades (Distribuição Normal)\n'),
        sprintf('P(nível < 50)     = %.4f\n', p1Normal),
        sprintf('P(45 < nível < 55) = %.4f\n', p2Normal),
        sprintf('P(nível > 60)     = %.4f\n', p3Normal),
        sprintf('Probabilidades (Valor Extremo - Gumbel)\n'),
        sprintf('P(nível < 50)     = %.4f\n', p1Gumbel),
        sprintf('P(45 < nível < 55) = %.4f\n', p2Gumbel),
        sprintf('P(nível > 60)     = %.4f\n', p3Gumbel)
    };

    criaGraficoTexto(sprintf('Questão 4: Probabilidades Normal e Valor Extremo - %s', baseDados), texto);
    
    %QUESTÃO 5%
    tamanho = length(nivelMar);
    fftDados = fft(nivelMar);
    fftAmplitude = abs(fftDados(2:floor(tamanho/2))) / (tamanho/2);
    frequencias = (1:floor(tamanho/2)-1) / tamanho;
    periodoDias = 1 ./ (frequencias * 24);
    omega = 2*pi*frequencias;
    
    figure;
    graficoFFT = plot(periodoDias, fftAmplitude, 'b');
    configuraGrafico(graficoFFT, sprintf('Questão 5: Transformada de Fourier - %s', baseDados), 'Período (dias)', 'Amplitude', {'Nível do Mar'});
    xlim([0 100]);
    
    
    [amplitudeTop5, idx] = maxk(fftAmplitude, 5);
    frequenciaTop5 = frequencias(idx);
    omegaTop5 = omega(idx);
    periodosTop5 = periodoDias(idx);
    
    
    tabelaTop5 = table(amplitudeTop5, omegaTop5', periodosTop5', 'VariableNames', {'Amplitude', 'Frequência Angular (radPorHora)', 'Período (dias)'});
    disp(tabelaTop5);

    %QUESTÃO 6%
    mediasMensais = zeros(12,1);
    desviosMensais = zeros(12,1);
    
    for m = 1:12
        indicesMes = mes == m;
        dadosMes = nivelMar(indicesMes);
        mediasMensais(m) = mean(dadosMes);
        desviosMensais(m) = std(dadosMes);
    end
    
    tabelaMediasDesvios = table((1:12)', mediasMensais, desviosMensais, 'VariableNames', {'Mês', 'Média', 'Desvio Padrão'});
    disp(tabelaMediasDesvios)
    
    figure;
    barraMediaMensal = bar(1:12, mediasMensais, 'FaceColor', [0.2 0.6 0.8]); hold on;
    errorbar(1:12, mediasMensais, desviosMensais, '.k', 'LineWidth', 1.5);
    xticks(1:12); xticklabels({'Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez'})
    configuraGrafico(barraMediaMensal, sprintf('Questão 6: Média Mensal - %s', baseDados), 'Mês', 'Nível do Mar (m)', {'Média Mensal', 'Desvio Padrão'});    

    [maiorMedia, mesMaiorMedia] = max(mediasMensais);
    [menorMedia, mesMenorMedia] = min(mediasMensais);
    [maiorVariabilidade, mesMaiorVariabilidade] = max(desviosMensais);
    
    texto = {
        sprintf('→ Maior média mensal:  Mês %d (%.3f m)', mesMaiorMedia, maiorMedia), 
        sprintf('→ Menor média mensal:  Mês %d (%.3f m)', mesMenorMedia, menorMedia),
        sprintf('→ Maior variabilidade: Mês %d (Desvio padrão: %.3f m)', mesMaiorVariabilidade, maiorVariabilidade)
    };

    criaGraficoTexto(sprintf('Questão 6: Médias e Variabilidades - %s', baseDados), texto);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function adicionaLinha(tipoLinha, eixo, estiloLinha, texto, alinhamentoHorizontal, alinhamentoVertical)
    if tipoLinha == 'x'
        xline(eixo, estiloLinha, texto, 'FontSize', 12, 'LabelHorizontalAlignment', alinhamentoHorizontal, 'LabelVerticalAlignment', alinhamentoVertical);
    else
        yline(eixo, estiloLinha, texto, 'FontSize', 12, 'LabelHorizontalAlignment', alinhamentoHorizontal, 'LabelVerticalAlignment', alinhamentoVertical);
    end
end

function configuraGrafico(grafico, titulo, xLabel, yLabel, legenda)
    axes(grafico.Parent);

    title(titulo);

    xlabel(xLabel, 'FontSize', 12);
    ylabel(yLabel, 'FontSize', 12);

    legend(legenda{:});

    grid on;

    %print(grafico);
end

function criaGraficoTexto(titulo, texto)
    figure;

    title(titulo);
    
    axis off;
    
    text(0.5, 0.5, texto, 'FontSize', 12, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
end