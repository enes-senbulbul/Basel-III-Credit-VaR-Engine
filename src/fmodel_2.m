function loss_matrix = fmodel_2(N_credits, N_simulations, EAD, PD, LGD, rho)
    M = randn(1, N_simulations);         % Ortak Ekonomik Faktör   
    Z = randn(N_credits, N_simulations); % Her Firmaya özgü riskler
    Threshold = norminv(PD);             % Temerrüt eşikleri
    Asset_Value = sqrt(rho)*M + sqrt(1-rho)*Z;
    default_matrix = Asset_Value < Threshold;
    loss_matrix = (EAD .* LGD) .* default_matrix;
end