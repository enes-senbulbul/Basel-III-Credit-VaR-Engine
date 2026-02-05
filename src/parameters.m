function [EAD_lim, PD_lim, LGD_lim, rho, r, T, conc_params] = parameters(m_choice)

    EAD_lim = [10000, 100000];
    PD_lim  = [0.01, 0.05];
    LGD_lim = [0.30, 0.90];
    rho = 0.15;          % Varlık Korelasyonu
    r = 0.08; T = 1;     % Model 3 için
    conc_params = 0.30;  % Model 4 için (İlk 10 kredinin ağırlığı)

    fprintf("\n--- Parametre Ayarları ---\n");
    fprintf("0 => Varsayılan Değerleri Kullan (Önerilen)\n");
    fprintf("1 => Kendi Değerlerini Gir (Özel)\n");
    fprintf("2 => Sadece Modele Özgü Değerleri Gir (Özel)\n");


    p_choice = -1; % Döngüye girmesi için geçici değer
    while ((p_choice ~= 0 && p_choice ~= 1) && p_choice ~= 2)
        p_choice = input("Seçiminiz (0, 1 veya 2): ");
        if ((p_choice ~= 0 && p_choice ~= 1) && p_choice ~= 2)
            fprintf("Hata: Lütfen sadece 0, 1 veya 2 giriniz.\n");
        end
    end

    if p_choice == 1
        fprintf("\n>>> Genel Portföy Parametrelerini Giriniz!\n");
        EAD_lim = input("Verilebilecek min ve max kredi miktarlarını giriniz (Örn: [10000, 100000]): ");
        PD_lim  = input("Min ve max batma ihtimallerini giriniz (Örn: [0.01, 0.05]): ");
        LGD_lim = input("Min ve max kayıp oranını giriniz (Örn: [0.30, 0.90]): ");

        % Model 1 (Bernoulli) haricindeki tüm modeller korelasyon (rho) kullanır.
        if m_choice > 1
            fprintf("\n>>> Model %d İçin Ek Parametreler:\n", m_choice);
            rho = input("Varlık korelasyonu (rho) değerini giriniz (Örn: 0.15): ");
        end

        % Modele Özgü Sorular (Switch-Case)
        switch m_choice
            case 3 % Zaman Değeri
                fprintf("--- Zaman Değeri Analizi Parametreleri ---\n");
                r = input("Yıllık risksiz faiz oranını giriniz (r) (Örn: 0.08): ");
                T = input("Vade süresini giriniz (Örn: 1): ");
                
            case 4 % Konsantrasyon Riski
                fprintf("--- Konsantrasyon Testi Parametreleri ---\n");
                fprintf("Varsayılan: İlk 10 krediye toplam portföyün %%30'u verilir.\n");
                conc_params = input("Konsantrasyon oranını giriniz (0.10 - 0.90 arası) (Örn: 0.30): ");
                
            case 5 % Çok Faktörlü (Cholesky)
                fprintf("--- Çok Faktörlü Model Notu ---\n");
                fprintf("Bu modelde sektör korelasyon matrisi kod içinde [1 0.4; 0.4 1] olarak sabittir.\n");
                disp("Korelasyon katsayısı (rho) yukarıda alındı.");
                
            otherwise
                % Model 1 ve 2 için ekstra soruya gerek yok (rho zaten alındı)
        end

    elseif p_choice == 2    
        % Model 1 (Bernoulli) haricindeki tüm modeller korelasyon (rho) kullanır.
        if m_choice > 1
            fprintf("\n>>> Model %d İçin Ek Parametreler:\n", m_choice);
            rho = input("Varlık korelasyonu (rho) değerini giriniz (Örn: 0.15): ");
        end
    
        % Modele Özgü Sorular (Switch-Case)
        switch m_choice
            case 3 % Zaman Değeri
                fprintf("--- Zaman Değeri Analizi Parametreleri ---\n");
                r = input("Yıllık risksiz faiz oranını giriniz (r) (Örn: 0.08): ");
                T = input("Vade süresini giriniz (Örn: 1): ");
                    
            case 4 % Konsantrasyon Riski
                fprintf("--- Konsantrasyon Testi Parametreleri ---\n");
                fprintf("Varsayılan: İlk 10 krediye toplam portföyün %%30'u verilir.\n");
                conc_params = input("Konsantrasyon oranını giriniz (0.10 - 0.90 arası) (Örn: 0.30): ");
                    
            case 5 % Çok Faktörlü (Cholesky)
                fprintf("--- Çok Faktörlü Model Notu ---\n");
                fprintf("Bu modelde sektör korelasyon matrisi kod içinde [1 0.4; 0.4 1] olarak sabittir.\n");
                disp("Korelasyon katsayısı (rho) yukarıda alındı.");
                    
            otherwise
                % Model 1 ve 2 için ekstra soruya gerek yok (rho zaten alındı)
            end


        else
            clc;
            fprintf("\nBilgi: Varsayılan parametrelerle devam ediliyor...\n");
            fprintf("--------------------------------------------\n");
            fprintf("   -> EAD Limitleri : %d - %d TL\n", EAD_lim(1), EAD_lim(2));
            fprintf("   -> PD Limitleri  : %% %.1f - %% %.1f\n", PD_lim(1)*100, PD_lim(2)*100);
            fprintf("   -> LGD Limitleri : %% %.1f - %% %.1f\n", LGD_lim(1)*100, LGD_lim(2)*100);
    
            % Modele Özgü Varsayılanların Listelenmesi
            if m_choice > 1
                 fprintf("   -> Varlık Korelasyonu (rho): %.2f\n", rho);
            end
    
            switch m_choice
                case 3
                    fprintf("   -> Risksiz Faiz Oranı (r)  : %.2f\n", r);
                    fprintf("   -> Vade Süresi (T)         : %d Yıl\n", T);
                case 4
                    fprintf("   -> Konsantrasyon Ağırlığı  : %% %.0f (İlk 10 Kredi)\n", conc_params*100);
                case 5
                    fprintf("   -> Sektörel Korelasyon     : Standart Matris [1 0.4; 0.4 1]\n");
            end
        end
end