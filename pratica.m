clear; close all; clc;

load dadosCananeia1988.dtf;
baseCananeia = dadosCananeia1988;

load baseUbatuba1988.dat;
baseUbatuba = dadosUbatuba1988;

calculaDados(baseCananeia);
calculaDados(baseUbatuba);

function calculaDados(arquivoDados)
    disp('');
    %%%%%%%%%%QUESTÃO 1: Estatísticas básicas dos dados%%%%%%%%%%

    tempo = arquivoDados(:, 1); ano = arquivoDados(:, 2); mes = arquivoDados(:, 3); dia = arquivoDados(:, 4); hora = arquivoDados(:, 5);
    nivelMar = arquivoDados(:, 6); indicadorQualidade = arquivoDados(:, 7);

    colunas = {'Tempo Acumulado', 'Ano', 'Mês', 'Dia', 'Hora', 'Nível do Mar', 'Indicador de Qualidade'};
    linhas = {'Mediana', 'Média', 'Moda', 'Máximo', 'Mínimo', 'Desvio Padrão'};
    %estatistica(1, 1:7) = [kurtosis(tempo) kurtosis(ano) kurtosis(mes) kurtosis(dia) kurtosis(hora) kurtosis(nivelMar) kurtosis(indicadorQualidade)]
    estatistica(1, 1:7) = [mean(tempo) mean(ano) mean(mes) mean(dia) mean(hora) mean(nivelMar) mean(indicadorQualidade)]
    estatistica(2, 1:7) = [median(tempo) median(ano) median(mes) median(dia) median(hora) median(nivelMar) median(indicadorQualidade)]
    estatistica(3, 1:7) = [mode(tempo) mode(ano) mode(mes) mode(dia) mode(hora) mode(nivelMar) mode(indicadorQualidade)]
    estatistica(4, 1:7) = [max(tempo) max(ano) max(mes) max(dia) max(hora) max(nivelMar) max(indicadorQualidade)]
    estatistica(5, 1:7) = [min(tempo) min(ano) min(mes) min(dia) min(hora) min(nivelMar) min(indicadorQualidade)]
    estatistica(6, 1:7) = [std(tempo) std(ano) std(mes) std(dia) std(hora) std(nivelMar) std(indicadorQualidade)]
    %estatistica(8, 1:7) = [skewness(tempo) skewness(ano) skewness(mes) skewness(dia) skewness(hora) skewness(nivelMar) skewness(indicadorQualidade)]
    
    tabelaEstatistica = array2table(estatistica, 'VariableNames', colunas, 'RowNames', linhas);
    disp(tabelaEstatistica);

    %%%%%%%%%%QUESTÃO 2: Valor médio e desvio padrão; série temporal e tendência%%%%%%%%%%
    mediaNivelMar = estatistica(1, 6);
    desvioNivelMar = estatistica(6, 6);
    tempoDias = tempo / 3600 / 24;
    
    figure;
    graficoValorDesvio = plot(tempoDias, nivelMar, 'b');
    configuraGrafico(graficoValorDesvio, 'Valor médio e desvio padrão', 'Tempo (dias)', 'Nível do Mar (m)')
    yline(mediaNivelMar, 'k-', 'Média', 'LabelVerticalAlignment', 'bottom', 'LabelHorizontalAlignment', 'left');
    
    corLinha = {'r--', 'g--', 'm--'};
    for i = 1:3
        yline(mediaNivelMar + i*desvioNivelMar, corLinha{i}, sprintf('+%dσ', i), 'LabelHorizontalAlignment', 'left');
        yline(mediaNivelMar - i*desvioNivelMar, corLinha{i}, sprintf('-%dσ', i), 'LabelHorizontalAlignment', 'left');
    end
    
    legend('Nível do Mar', 'Média', '+1σ', '-1σ', '+2σ', '-2σ', '+3σ', '-3σ');
    
    coefTrend = polyfit(tempoDias, nivelMar, 1);
    tendencia = polyval(coefTrend, tempoDias);
    
    figure;
    graficoNivelMar = plot(tempoDias, nivelMar, 'b');
    hold on;
    graficoTendencia = plot(tempoDias, tendencia, 'r');
    configuraGrafico(graficoNivelMar, 'Série temporal e tendência', 'Tempo (dias)', 'Nível do Mar (m)');
    taxaVariacao = coefTrend(1);
    yline(taxaVariacao, 'k--', ['Taxa de Variação: ', num2str(taxaVariacao, '%.4f'), 'M/Dia'], 'LabelVerticalAlignment', 'bottom', 'LabelHorizontalAlignment', 'left');
    legend('Nível do Mar', 'Tendência', 'Variação');

    %QUESTÃO 3

    figure;
    histogramaNivelMar = histogram(nivelMar);
    configuraGrafico(histogramaNivelMar, 'Histograma do Nível do Mar', 'Nível do Mar (m)', 'Frequência')
    
    frequenciaMaxima = max(histogramaNivelMar.Values);
    percentuais = [10 25 75 90];
    percentis = prctile(nivelMar, percentuais);
    hold on;

    for i = 1:length(percentis)
        xline(percentis(i), '--', sprintf('P%d', percentuais(i)), 'LabelHorizontalAlignment', 'center', 'LabelVerticalAlignment', 'bottom', 'Color', 'r');
    end
    
    corLinha = {'r', 'g', 'b', 'm'};
    for i = 1:length(percentuais)
        x = percentis(i);
        y = ylim;
        line([x x], y, 'Color', corLinha{i}, 'LineStyle', '--', 'LineWidth', 1.5);
        
        text(x, y(2)*0.95, sprintf('P%d: %.2f', percentuais(i), x), 'Rotation', 90, 'VerticalAlignment', 'top', 'HorizontalAlignment', 'right', 'Color', corLinha{i});
    end

    legend('Nível do Mar', 'Percentis');

    %QUESTÃO 4
%     betaGumbel = sqrt(6)*desvioNivelMar/pi;
%     muGumbel = mediaNivelMar - 0.5772 * betaGumbel;
%     
%     incremento = input('Forneça incremento para cálculo da fdp, ex: 0.015: ');
%     
%     minNivelMar = mediaNivelMar - 4*desvioNivelMar;
%     maxNivelMar = mediaNivelMar + 4*desvioNivelMar;
%     nivel = minNivelMar:incremento:maxNivelMar;
%     
%     fdpNormal = exp(-(((nivel - mediaNivelMar) / desvioNivelMar).^2) / 2) / (desvioNivelMar * sqrt(2*pi));
%     
%     z = (nivel - muGumbel) / betaGumbel;
%     fdpGumbel = (1/betaGumbel) * exp(-(z + exp(-z)));
%     
%     figure
%     graficoFdpNormal = plot(nivel, fdpNormal, 'b-', 'LineWidth', 2)
%     hold on
%     graficoFdpGumbel = plot(nivel, fdpGumbel, 'g--', 'LineWidth', 2)
%     configuraGrafico(graficoFdpNormal, 'Função Densidade', 'Nível do Mar (m)', 'FDP');
%     legend('Normal', 'Valor Extremo (Gumbel)')
%     
%     p1Normal = normcdf(50, mediaNivelMar, desvioNivelMar);                         % P(elev < 50)
%     p2Normal = normcdf(55, mediaNivelMar, desvioNivelMar) - normcdf(45, mediaNivelMar, desvioNivelMar);  % P(45 < elev < 55)
%     p3Normal = 1 - normcdf(60, mediaNivelMar, desvioNivelMar);                     % P(elev > 60)
%     
%     p1Gumbel = exp(-exp(-(50 - muGumbel)/betaGumbel));                         % P(elev < 50)
%     p2Gumbel = exp(-exp(-(55 - muGumbel)/betaGumbel)) - exp(-exp(-(45 - muGumbel)/betaGumbel));  % P(45 < elev < 55)
%     p3Gumbel = 1 - exp(-exp(-(60 - muGumbel)/betaGumbel));                     % P(elev > 60)
%     
%     infoTexto = {
%         sprintf('\n--- Probabilidades (Distribuição Normal) ---\n'),
%         sprintf('P(elev < 50)     = %.4f\n', p1Normal),
%         sprintf('P(45 < elev < 55)= %.4f\n', p2Normal),
%         sprintf('P(elev > 60)     = %.4f\n', p3Normal),
%         sprintf('\n--- Probabilidades (Valor Extremo - Gumbel) ---\n'),
%         sprintf('P(elev < 50)     = %.4f\n', p1Gumbel),
%         sprintf('P(45 < elev < 55)= %.4f\n', p2Gumbel),
%         sprintf('P(elev > 60)     = %.4f\n', p3Gumbel)
%     };
%     
%     for i = 1:length(infoTexto)
%         text(0.01, 0.95 - (i-1)*0.06, infoTexto{i}, 'Units', 'normalized', 'Color', 'k', 'FontWeight', 'bold', 'Interpreter', 'none');
%     end

    %QUESTÃO 5
    nivelMar = nivelMar - mean(nivelMar);
    tamanho = length(nivelMar);
    fftDados = fft(nivelMar);
    fftAmplitude = abs(fftDados(2:floor(tamanho/2))) / (tamanho/2);
    
    frequencias = (1:floor(tamanho/2)-1) / tamanho;
    periodoDias = 1 ./ (frequencias * 24);
    omega = 2*pi*frequencias;
    
    figure;
    graficoFFT = plot(periodoDias, fftAmplitude, 'b', 'LineWidth', 1.5);
    configuraGrafico(graficoFFT, 'Transformada de Fourier', 'Período (dias)', 'Amplitude');
    xlim([0 100]);

    figure;
    graficoFFT = plot(periodoDias, fftAmplitude, 'b', 'LineWidth', 1.5);
    configuraGrafico(graficoFFT, 'Transformada de Fourier', 'Período (dias)', 'Amplitude');
    xlim([0 100]);
    
    
    [amplitudeTop5, idx] = maxk(fftAmplitude, 5);
    frequenciaTop5 = frequencias(idx);
    omegaTop5 = omega(idx);
    periodosTop5 = periodoDias(idx);
    
    
    tabelaTop5 = table(amplitudeTop5, omegaTop5', periodosTop5', 'VariableNames', {'Amplitude', 'Frequência Angular (radPorHora)', 'Período (dias)'});
    disp(tabelaTop5);

    %QUESTÃO 6
    mediasMensais = zeros(12,1);
    desviosMensais = zeros(12,1);
    
    for m = 1:12
        indicesMes = mes == m;
        dadosMes = nivelMar(indicesMes);
        mediasMensais(m) = mean(dadosMes);
        desviosMensais(m) = std(dadosMes);
    end
    
    tabelaMdiasDesvios = table((1:12)', mediasMensais, desviosMensais, 'VariableNames', {'Mês', 'Média', 'Desvio Padrão'});
    disp(tabelaMdiasDesvios)
    
    figure;
    barraMediaMensal = bar(1:12, mediasMensais, 'FaceColor', [0.2 0.6 0.8]); hold on;
    errorbar(1:12, mediasMensais, desviosMensais, '.k', 'LineWidth', 1.5);
    xticks(1:12); xticklabels({'Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez'})
    configuraGrafico(barraMediaMensal, 'Média mensal', 'Mês', 'Nível do Mar (m)');
    legend('Média Mensal', 'Desvio Padrão');
    
    [maiorMedia, mesMaiorMedia] = max(mediasMensais);
    [menorMedia, mesMenorMedia] = min(mediasMensais);
    [maiorVariabilidade, mesMaiorVariabilidade] = max(desviosMensais);
    
    infoTexto = {
        sprintf('→ Maior média mensal:  Mês %d (%.3f m)', mesMaiorMedia, maiorMedia), 
        sprintf('→ Menor média mensal:  Mês %d (%.3f m)', mesMenorMedia, menorMedia),
        sprintf('→ Maior variabilidade: Mês %d (Desvio padrão: %.3f m)', mesMaiorVariabilidade, maiorVariabilidade)
    };
    
    for i = 1:length(infoTexto)
        text(0.01, 0.95 - (i-1)*0.06, infoTexto{i}, 'Units', 'normalized', 'Color', 'k', 'FontWeight', 'bold', 'Interpreter', 'none');
    end
end

% function botaTexto(valorFinal)
%     for i = 1:valorFinal
%         text(0.01, 0.95 - (i - 1) * 0.06, texto{i}, 'Units', 'normalized');
%     end
% end


function configuraGrafico(grafico, titulo, xLabel, yLabel)
    axes(grafico.Parent);

    title(titulo);

    xlabel(xLabel, 'fontsize', 12);
    ylabel(yLabel, 'fontsize', 12);

    grid on;

    %print(grafico);
end