function loss_matrix = fmodel_1(N_credits, N_simulations, EAD, PD, LGD)
    default_matrix = rand(N_credits, N_simulations) < PD; % Temerrüt(Default) Matrisi
    loss_matrix = (EAD .* LGD) .* default_matrix;
end
