clc;

% Carregar os dados
load dadosCananeia1988.dtf
dados = dadosCananeia1988;
meses = dados(:, 3);       % coluna com o mês
nivelMar = dados(:, 6);    % coluna com nível do mar

% Inicialização
mediasMensais = zeros(12,1);
desviosMensais = zeros(12,1);

for m = 1:12
    indicesMes = find(meses == m);
    dadosMes = nivelMar(indicesMes);
    mediasMensais(m) = mean(dadosMes);
    desviosMensais(m) = std(dadosMes);
end
% Tabela de resultados
T = table((1:12)', mediasMensais, desviosMensais, ...
    'VariableNames', {'Mes', 'Media', 'DesvioPadrao'});
disp(T)

% Gráfico de barras com barras de erro
figure;
bar(1:12, mediasMensais, 'FaceColor', [0.2 0.6 0.8]); hold on;
errorbar(1:12, mediasMensais, desviosMensais, '.k', 'LineWidth', 1.5);
xticks(1:12); xticklabels({'Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez'})
xlabel('Mês');
ylabel('Nível do Mar (m)');
title('Médias mensais com desvio padrão');
grid on;

% Identificar meses de interesse
[maiorMedia, mesMaiorMedia] = max(mediasMensais);
[menorMedia, mesMenorMedia] = min(mediasMensais);
[maiorVariab, mesMaiorVariab] = max(desviosMensais);

fprintf('\n→ Maior média mensal: Mês %d (%.3f m)\n', mesMaiorMedia, maiorMedia);
fprintf('→ Menor média mensal: Mês %d (%.3f m)\n', mesMenorMedia, menorMedia);
fprintf('→ Maior variabilidade: Mês %d (Desvio padrão: %.3f m)\n', mesMaiorVariab, maiorVariab);

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


% clear; close all; clc;
% 
% %Lendo arquivo de dados
% load dadosCananeia1988.dtf;
% arquivoDados = dadosCananeia1988;
% 
% % load uba1988.dat;
% % arquivoDados = uba1988;
% 
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