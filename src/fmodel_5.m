function loss_matrix = fmodel_5(N_credits, N_simulations, EAD, PD, LGD, rho)

    M = randn(1, N_simulations);         % Ortak Ekonomik Faktör   
    Z = randn(N_credits, N_simulations); % Her Firmaya özgü riskler
    Threshold = norminv(PD);             % Temerrüt eşikleri

    R = [1.0, 0.4;
         0.4, 1.0]; % Sektör korelasyon matrisi
    L = chol(R, 'lower');     % Cholesky faktörü 

    M_ind = randn(2, N_simulations);
    M_corr = L * M_ind;       % Korelasyonlu faktörler
    sec = randi([1,2], N_credits, 1);
    Asset_V = zeros(N_credits, N_simulations);

    for s=1:2
        idx = (sec==s);
        Asset_V(idx,:) = sqrt(rho)*M_corr(s,:) + sqrt(1-rho)*Z(idx,:);
    end
    
    loss_matrix = (EAD .* LGD) .* (Asset_V < Threshold);
end
