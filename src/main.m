%% ITU - MAT116E Project - Monte Carlo Simulations for Credit Portfolio Risk
% Enes Senbulbul 090240735

clc; clear; close all;
rng(93);

fprintf("Monte Carlo Yöntemi ile Kredi Portföyü Analizimize Hoş Geldiniz!\n");
N_credits = input("Portföydeki kredi sayısını giriniz (Örn:1000): ");
N_simulations = input("Monte Carlo Yöntemi ile denenecek simülasyon sayısını giriniz (Örn: 10000): "); 
confidence_lvl = input("Bankanın uyması gereken güven seviyesini (VaR) seçin!\nAAA notlu bankalar için 0.999 şarttır. Yüksek sermaye rezervi bulundurmaları gerekir.\nDaha riskli bir yaklaşım için 0.95 denenebilir. Sermaye ihtiyacı azalır ama felaket riski artar.\n>>> "); 

clc;
fprintf("Analiz Modelleri:\n");
fprintf("1: Bağımsız Model (Bernoulli) \n");
fprintf("2: Bağımlı Model (Vasicek - Sistemik Risk) \n");
fprintf("3: Bağımlı Modelde Zaman Değeri Analizi (İskonto Edilmiş) \n");
fprintf("4: Bağımlı Model Konsantrasyon Riski Testi (Granüler vs Konsantre) \n");
fprintf("5: Çok Faktörlü Model (Sektörel Korelasyon - Cholesky) \n");
m_choice = input("Seçiminizi yapın (1-5): ");

clc;

[EAD_lim, PD_lim, LGD_lim, rho, r, T, conc_params] = parameters(m_choice);


% Parametrelerin Üretilmesi
EAD = EAD_lim(1) + (EAD_lim(2)-EAD_lim(1)) * rand(N_credits, 1); 
PD  = PD_lim(1)  + (PD_lim(2)-PD_lim(1))  * rand(N_credits, 1);      
LGD = LGD_lim(1) + (LGD_lim(2)-LGD_lim(1)) * rand(N_credits, 1);



switch m_choice
    case 1
        loss_matrix = fmodel_1(N_credits, N_simulations, EAD, PD, LGD);
    case 2
        loss_matrix = fmodel_2(N_credits, N_simulations, EAD, PD, LGD, rho);
    case 3
        loss_matrix = fmodel_3(N_credits, N_simulations, EAD, PD, LGD, rho, r, T);
    case 4
        loss_matrix = fmodel_4(N_credits, N_simulations, EAD, PD, LGD, rho, conc_params);
    case 5
        loss_matrix = fmodel_5(N_credits, N_simulations, EAD, PD, LGD, rho);
    otherwise 
end


Total_Losses = sum(loss_matrix, 1)';


EL_analitik = sum(EAD .* LGD .* PD);
if m_choice == 3
    df = exp(-r * T); 
    EL_analitik = EL_analitik * df; 
end
EL_sim = mean(Total_Losses);
VaR = prctile(Total_Losses, confidence_lvl * 100);
ES = mean(Total_Losses(Total_Losses > VaR));
UL = VaR - EL_sim;

format bank


Risk_Metrigi = [
    "Expected Loss (EL)"
    "Value-at-Risk (VaR)"
    "Expected Shortfall (ES)"
    "Capital Reserve (UL)"
];

ResultTable = table(Risk_Metrigi,[EL_sim; VaR; ES; UL], ...
                    'VariableNames', {'Risk_Metrigi', 'Deger_TL'});


fprintf("\n====================================================\n");
fprintf("           RİSK ANALİZ RAPORU (ÖZET)\n");
fprintf("====================================================\n");
disp(ResultTable);

fprintf("Kredi Sayısı: %d | Simülasyon Sayısı: %d | Güven Seviyesi: %%%.1f\n", N_credits, N_simulations, confidence_lvl*100);
fprintf("Analitic Expected Loss: %.2f TL | Simulated Expected Loss: %.2f TL \nSimülasyon Hatası: %.2f%%\n", ...
        EL_analitik, EL_sim, abs(EL_sim-EL_analitik)/EL_analitik*100);
fprintf("====================================================\n");

colors = [
    0.70 0.85 1.00;  % Açık mavi
    0.70 1.00 0.70;  % Açık yeşil
    1.00 0.80 0.80;  % Açık kırmızı / pembe
    1.00 0.90 0.70;  % Açık turuncu
    0.85 0.75 1.00;  % Açık mor
    0.75 0.95 0.95;  % Açık camgöbeği
];

face_color = colors(6,:);
switch m_choice
    case 1, face_color = colors(1,:);
    case 2, face_color = colors(2,:);
    case 3, face_color = colors(3,:);
    case 4, face_color = colors(4,:);
    case 5, face_color = colors(5,:);
end

figure("WindowState", "normal");
histogram(Total_Losses, 100, 'Normalization', 'pdf', 'FaceColor', face_color, "FaceAlpha", 0.4);
hold on;
xline(VaR, 'r', 'LineWidth', 2, 'Label', 'Value at Risk (VaR)',"FontSize",15);
xline(ES, 'y--', 'LineWidth', 2, 'Label', 'Expected Shortfall (ES)',"FontSize",15);

dx = 0.002 * range(Total_Losses); % Offset to distinguish both
xline(EL_analitik + dx, 'g-',  'LineWidth', 1.5, 'Label', 'Expected Loss (Analitic)','LabelOrientation','horizontal','LabelVerticalAlignment','top',"FontSize",15);
xline(EL_sim - dx, 'm-', 'LineWidth', 1.5, 'Label', 'Expected Loss (Simulated)','LabelOrientation','horizontal',"LabelHorizontalAlignment","left",'LabelVerticalAlignment','top',"FontSize",15);

title(['Credit Portfolio Loss Distribution - Model ' num2str(m_choice)],"FontSize",15);
xlabel('Total Default Loss (TL)','FontSize',13); ylabel('Probability Density'); grid on;




