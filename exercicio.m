clear; close all; clc;

% Carregar os dados
% load dadosCananeia1988.dtf
% dados = dadosCananeia1988;

load dadosUbatuba1988.dat
dados = dadosUbatuba1988;
elev = dados(:, 6);

% Cálculo da distribuição normal e valor extremo para os dados 'elev'

mediaNivelMar = mean(elev);
desvioNivelMar = std(elev);
betaGumbel = sqrt(6)*desvioNivelMar/pi;
muGumbel = mediaNivelMar - 0.5772 * betaGumbel;

incremento = input('Forneça incremento para cálculo da fdp, ex: 0.015: ');

minNivelMar = mediaNivelMar - 4*desvioNivelMar;
maxNivelMar = mediaNivelMar + 4*desvioNivelMar;
nivel = minNivelMar:incremento:maxNivelMar;

fdpNormal = exp(-(((nivel - mediaNivelMar) / desvioNivelMar).^2) / 2) / (desvioNivelMar * sqrt(2*pi));

z = (nivel - muGumbel) / betaGumbel;
fdpGumbel = (1/betaGumbel) * exp(-(z + exp(-z)));

figure
graficoFdpNormal = plot(nivel, fdpNormal, 'b-', 'LineWidth', 2)
hold on
graficoFdpGumbel = plot(nivel, fdpGumbel, 'g--', 'LineWidth', 2)
configuraGrafico(graficoFdpNormal, 'Função Densidade', 'Nível do Mar (m)', 'FDP');
legend('Normal', 'Valor Extremo (Gumbel)')

p1Normal = normcdf(50, mediaNivelMar, desvioNivelMar);                         % P(elev < 50)
p2Normal = normcdf(55, mediaNivelMar, desvioNivelMar) - normcdf(45, mediaNivelMar, desvioNivelMar);  % P(45 < elev < 55)
p3Normal = 1 - normcdf(60, mediaNivelMar, desvioNivelMar);                     % P(elev > 60)

p1Gumbel = exp(-exp(-(50 - muGumbel)/betaGumbel));                         % P(elev < 50)
p2Gumbel = exp(-exp(-(55 - muGumbel)/betaGumbel)) - exp(-exp(-(45 - muGumbel)/betaGumbel));  % P(45 < elev < 55)
p3Gumbel = 1 - exp(-exp(-(60 - muGumbel)/betaGumbel));                     % P(elev > 60)

infoTexto = {
    sprintf('\n--- Probabilidades (Distribuição Normal) ---\n'),
    sprintf('P(elev < 50)     = %.4f\n', p1Normal),
    sprintf('P(45 < elev < 55)= %.4f\n', p2Normal),
    sprintf('P(elev > 60)     = %.4f\n', p3Normal),
    sprintf('\n--- Probabilidades (Valor Extremo - Gumbel) ---\n'),
    sprintf('P(elev < 50)     = %.4f\n', p1Gumbel),
    sprintf('P(45 < elev < 55)= %.4f\n', p2Gumbel),
    sprintf('P(elev > 60)     = %.4f\n', p3Gumbel)
};

for i = 1:length(infoTexto)
    text(0.01, 0.95 - (i-1)*0.06, infoTexto{i}, 'Units', 'normalized', 'Color', 'k', 'FontWeight', 'bold', 'Interpreter', 'none');
end


% nivelMar = dados(:, 6);    % coluna 6 = nível do mar
% 
% % Remover a média (centralizar os dados)
% nivelMar = nivelMar - mean(nivelMar);
% 
% 
% tamanho = length(nivelMar);
% fftDados = fft(nivelMar);
% fftAmplitude = abs(fftDados(2:floor(tamanho/2))) / (tamanho/2);
% 
% frequencias = (1:floor(tamanho/2)-1) / tamanho;
% periodoDias = 1 ./ (frequencias * 24);
% omega = 2*pi*frequencias;
% 
% 
% figure;
% graficoFFT = plot(periodoDias, fftAmplitude, 'b', 'LineWidth', 1.5);
% configuraGrafico(graficoFFT, 'Transformada de Fourier', 'Período (dias)', 'Amplitude');
% xlim([0 100]);
% 
% 
% [amplitudeTop5, idx] = maxk(fftAmplitude, 5);
% frequenciaTop5 = frequencias(idx);
% omegaTop5 = omega(idx);
% periodosTop5 = periodoDias(idx);
% 
% 
% tabelaTop5 = table(amplitudeTop5, omegaTop5', periodosTop5', 'VariableNames', {'Amplitude', 'Frequência_Angular_radPorHora', 'Período_dias'});
% disp(tabelaTop5);
% 
% 
function configuraGrafico(grafico, titulo, xLabel, yLabel)
    axes(grafico.Parent);

    title(titulo);

    xlabel(xLabel, 'fontsize', 12);
    ylabel(yLabel, 'fontsize', 12);

    grid on;

    %print(grafico);
end

% clear; close all; clc;
% 
% % Carregar os dados
% load dadosCananeia1988.dtf
% nivelMar = dadosCananeia1988(:, 6);

% % Parâmetros estatísticos
% mu = mean(nivelMar);
% sigma = std(nivelMar);
% 
% % Ajuste Gumbel (valor extremo)
% [paramGumbel, ~] = evfit(nivelMar); % distrib. valor extremo (Gumbel)
% mu_gumbel = paramGumbel(1);
% sigma_gumbel = paramGumbel(2);
% 
% % Intervalo para plotagem
% x = linspace(min(nivelMar), max(nivelMar), 100);
% 
% % PDFs
% pdf_normal = normpdf(x, mu, sigma);
% pdf_gumbel = evpdf(x, mu_gumbel, sigma_gumbel);
% 
% % Plot das distribuições
% figure;
% plot(x, pdf_normal, 'b', 'LineWidth', 2); hold on;
% plot(x, pdf_gumbel, 'r--', 'LineWidth', 2);
% grid on;
% legend('Normal', 'Valor Extremo (Gumbel)');
% xlabel('Nível do Mar (m)');
% ylabel('Densidade de Probabilidade');
% title('Distribuições Normal e de Valor Extremo');
% 
% % Probabilidades
% p1_normal = 1 - normcdf(mu, mu, sigma);             % P(X > média)
% p2_normal = 1 - normcdf(mu + sigma, mu, sigma);     % P(X > média + 1σ)
% p3_normal = 1 - normcdf(mu + 2*sigma, mu, sigma);   % P(X > média + 2σ)
% 
% p1_gumbel = 1 - evcdf(mu, mu_gumbel, sigma_gumbel);
% p2_gumbel = 1 - evcdf(mu + sigma, mu_gumbel, sigma_gumbel);
% p3_gumbel = 1 - evcdf(mu + 2*sigma, mu_gumbel, sigma_gumbel);
% 
% % Exibir os resultados
% fprintf('--- Distribuição Normal ---\n');
% fprintf('P(Nível > média)          = %.4f\n', p1_normal);
% fprintf('P(Nível > média + 1σ)     = %.4f\n', p2_normal);
% fprintf('P(Nível > média + 2σ)     = %.4f\n\n', p3_normal);
% 
% fprintf('--- Distribuição Gumbel (Valor Extremo) ---\n');
% fprintf('P(Nível > média)          = %.4f\n', p1_gumbel);
% fprintf('P(Nível > média + 1σ)     = %.4f\n', p2_gumbel);
% fprintf('P(Nível > média + 2σ)     = %.4f\n', p3_gumbel);

% nudad = size(arquivoDados, 1);
% elev = arquivoDados(:, 6);
% 
% n2=nudad/2;
% n=1:n2;
% Tn_horas=nudad./n;
% Tn_dias=nudad./n/24;
% Fn=1./Tn_dias;
% altura_media=mean(elev);
% elev=elev-altura_media;
% elev = elev-mean(elev);
% fft_elev=fft(elev);
% fft_elev2=fft_elev(2:n2+1);
% a_fft_elev=abs(fft_elev2)/n2;
% 
% figure
% bar(Tn_dias,a_fft_elev,'LineWidth',2)
% grid on
% title('pto p05 201604 delft temp (Transf. Fourier)','fontsize',12)
% xlabel('Periodos (em dias)','fontsize',12)
% ylabel('Amplitude (em C)','fontsize',12)
% 
% 
% numeroDados = size(arquivoDados, 1);
% nivelMar = arquivoDados(:, 6);