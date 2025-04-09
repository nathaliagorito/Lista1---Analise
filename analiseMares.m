clear; close all; clc;

%Lendo arquivo de dados
load dadosCananeia1988.dtf;
arquivoDados = dadosCananeia1988;

%Separando dados
tempoAcumulado = arquivoDados(:, 1);
ano = arquivoDados(:, 2);
mes = arquivoDados(:, 3);
dia = arquivoDados(:, 4);
hora = arquivoDados(:, 5);
nivelMar = arquivoDados(:, 6);
indicadorQualidade = arquivoDados(:, 7);

%%%%%%%%%%QUESTÃO 1: Estatísticas básicas dos dados%%%%%%%%%%
colunas = {'Tempo Acumulado', 'Ano', 'Mês', 'Dia', 'Hora', 'Nível do Mar', 'Indicador de Qualidade'};
linhas = {'Mediana', 'Média', 'Moda', 'Máximo', 'Mínimo', 'Desvio Padrão'};
%estatistica(1, 1:7) = [kurtosis(tempoAcumulado) kurtosis(ano) kurtosis(mes) kurtosis(dia) kurtosis(hora) kurtosis(nivelMar) kurtosis(indicadorQualidade)]
estatistica(1, 1:7) = [mean(tempoAcumulado) mean(ano) mean(mes) mean(dia) mean(hora) mean(nivelMar) mean(indicadorQualidade)]
estatistica(2, 1:7) = [median(tempoAcumulado) median(ano) median(mes) median(dia) median(hora) median(nivelMar) median(indicadorQualidade)]
estatistica(3, 1:7) = [mode(tempoAcumulado) mode(ano) mode(mes) mode(dia) mode(hora) mode(nivelMar) mode(indicadorQualidade)]
estatistica(4, 1:7) = [max(tempoAcumulado) max(ano) max(mes) max(dia) max(hora) max(nivelMar) max(indicadorQualidade)]
estatistica(5, 1:7) = [min(tempoAcumulado) min(ano) min(mes) min(dia) min(hora) min(nivelMar) min(indicadorQualidade)]
estatistica(6, 1:7) = [std(tempoAcumulado) std(ano) std(mes) std(dia) std(hora) std(nivelMar) std(indicadorQualidade)]
%estatistica(8, 1:7) = [skewness(tempoAcumulado) skewness(ano) skewness(mes) skewness(dia) skewness(hora) skewness(nivelMar) skewness(indicadorQualidade)]

tabelaEstatistica = array2table(estatistica, 'VariableNames', colunas, 'RowNames', linhas);
disp(tabelaEstatistica);

%%%%%%%%%%QUESTÃO 2: Valor médio e desvio padrão; série temporal e tendência%%%%%%%%%%
mediaNivelMar = estatistica(1, 6);
desvioNivelMar = estatistica(6, 6);
tempoDias = tempoAcumulado / 3600 / 24; %Conversão de segundos para dias

%Gráfico valor médio e desvio padrão
figure;
graficoValorDesvio = plot(tempoDias, nivelMar, 'b');
configuraGrafico(graficoValorDesvio, 'Valor médio e desvio padrão', 'Tempo (dias)', 'Nível do Mar (m)', 'graficoValorDesvio')
yline(mediaNivelMar, 'k-', 'Média', 'LabelVerticalAlignment', 'bottom', 'LabelHorizontalAlignment', 'left');

corLinha = {'r--', 'g--', 'm--'};
for i = 1:3
    yline(mediaNivelMar + i*desvioNivelMar, corLinha{i}, sprintf('+%dσ', i), 'LabelHorizontalAlignment', 'left');
    yline(mediaNivelMar - i*desvioNivelMar, corLinha{i}, sprintf('-%dσ', i), 'LabelHorizontalAlignment', 'left');
end

legend('Nível do Mar', 'Média', '+1σ', '-1σ', '+2σ', '-2σ', '+3σ', '-3σ');

%Gráfico série temporal e tendência
coefTrend = polyfit(tempoDias, nivelMar, 1);
tendencia = polyval(coefTrend, tempoDias);

figure;
graficoNivelMar = plot(tempoDias, nivelMar, 'b');
hold on;
graficoTendencia = plot(tempoDias, tendencia, 'r');
configuraGrafico(graficoNivelMar, 'Série temporal e tendência', 'Tempo (dias)', 'Nível do Mar (m)', 'graficoSerieTendencia');

taxaVariacao = coefTrend(1);
yline(taxaVariacao, 'k--', ['Taxa de Variação: ', num2str(taxaVariacao, '%.4f'), 'M/Dia'], 'LabelVerticalAlignment', 'bottom', 'LabelHorizontalAlignment', 'left');
legend('Nível do Mar', 'Tendência', 'Variação');

%%%%%%%%%%QUESTÃO 3%%%%%%%%%%
figure;
histogramaNivelMar = histogram(nivelMar);
configuraGrafico(histogramaNivelMar, 'Histograma do Nível do Mar', 'Nível do Mar (m)', 'Frequência', 'histogramaNivelMar')

frequenciaMaxima = max(histogramaNivelMar.Values);
percentuais = [10 25 75 90];
percentis = prctile(nivelMar, percentuais);

% Exibir os valores dos percentis
fprintf('Percentil 10: %.4f\n', percentis(1));
fprintf('Percentil 25: %.4f\n', percentis(2));
fprintf('Percentil 75: %.4f\n', percentis(3));
fprintf('Percentil 90: %.4f\n', percentis(4));

% Plot dos percentis sobre o histograma
hold on;
for i = 1:length(percentis)
    xline(percentis(i), '--', sprintf('P%d', percentuais(i)), 'LabelHorizontalAlignment', 'center', 'LabelVerticalAlignment', 'bottom', 'Color', 'r');
end
% Marcar e anotar os percentis no gráfico
cores = {'r', 'g', 'b', 'm'};
for i = 1:length(percentuais)
    x = percentis(i);
    y = ylim; % obtém o limite do eixo y para posicionar a linha
    line([x x], y, 'Color', cores{i}, 'LineStyle', '--', 'LineWidth', 1.5);
    
    % Escreve o texto no topo da linha
    text(x, y(2)*0.95, ...
        sprintf('P%d: %.2f', percentuais(i), x), ...
        'Rotation', 90, ...
        'VerticalAlignment', 'top', ...
        'HorizontalAlignment', 'right', ...
        'FontSize', 10, ...
        'Color', cores{i});
end
legend('Nível do Mar', 'Percentis');

function configuraGrafico(grafico, titulo, xLabel, yLabel, nomeArquivo)
    axes(grafico.Parent);

    title(titulo);

    xlabel(xLabel, 'fontsize', 12);
    ylabel(yLabel, 'fontsize', 12);

    grid on;

    print(nomeArquivo);
end
