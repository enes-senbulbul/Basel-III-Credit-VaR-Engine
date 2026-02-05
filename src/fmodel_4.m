function loss_matrix = fmodel_4(N_credits, N_simulations, EAD, PD, LGD, rho, conc_params)
    M = randn(1, N_simulations);         % Ortak Ekonomik Faktör   
    Z = randn(N_credits, N_simulations); % Her Firmaya özgü riskler
    Threshold = norminv(PD);             % Temerrüt eşikleri
    EAD_conc = ones(N_credits, 1) * mean(EAD);
    EAD_conc(1:10) = sum(EAD)*conc_params / 10; % İlk 10 krediye %30 ağırlık
    EAD_conc(11:end) = sum(EAD) * (1-conc_params) / (N_credits - 10); % Kalanlara % 70 ağırlık
    default_matrix = (sqrt(rho)*M + sqrt(1-rho)*Z) < Threshold;
    loss_matrix = (EAD_conc .* LGD) .* default_matrix;
end