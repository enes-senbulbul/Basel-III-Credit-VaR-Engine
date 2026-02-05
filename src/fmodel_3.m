function loss_matrix = fmodel_3(N_credits, N_simulations, EAD, PD, LGD, rho, r, T)
    M = randn(1, N_simulations);         % Ortak Ekonomik Faktör   
    Z = randn(N_credits, N_simulations); % Her Firmaya özgü riskler
    Threshold = norminv(PD);             % Temerrüt eşikleri
    df = exp(-r * T); 
    default_matrix = (sqrt(rho)*M + sqrt(1-rho)*Z) < Threshold;
    loss_matrix = ((EAD .* LGD) .* default_matrix) * df;
end