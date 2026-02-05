# Quantitative Credit Risk Stress Testing Engine

![MATLAB](https://img.shields.io/badge/MATLAB-R2025b-orange.svg)

> **ITU Mathematical Engineering - MAT116E Term Project**
> **Author:** Enes Şenbülbül

## 👋 About This Project
This repository serves as the **starting point of my open-source software development journey**. 

It was originally developed as a term project for the **MAT116E (Advanced Scientific and Engineering Computing)** course at **Istanbul Technical University (ITU)**. The goal was to build a robust simulation engine to analyze financial risks, demonstrating the intersection of mathematical modelling and software engineering.

## 📌 Project Overview
This project is a high-performance **Monte Carlo Simulation engine** developed to analyze financial risks within a credit portfolio. It is designed to calculate regulatory capital requirements (**VaR** and **Expected Shortfall**) under various economic scenarios, aligned with **Basel III** stress-testing standards.

The simulation processes thousands of credit scenarios to estimate potential losses, highlighting the difference between independent defaults and systemic economic crises.

## 🚀 Key Features & Financial Models
The engine implements **5 distinct risk models**, allowing for a comparative analysis of portfolio stability:

* **Model 1: Independent Risk (Bernoulli)**
    * Baseline model assuming zero correlation between borrowers.
    * *Mathematical Basis:* Independent Bernoulli trials.
* **Model 2: Systemic Risk (Vasicek Model)**
    * Simulates economic downturns affecting all borrowers simultaneously.
    * *Key Insight:* Demonstrated a **9.2x increase** in Unexpected Loss (UL) compared to the independent model due to asset correlation.
* **Model 3: Time Value of Money**
    * Incorporates continuous discounting ($df = e^{-rT}$) to calculate the Present Value of future losses.
* **Model 4: Concentration Risk**
    * Stress-tests the portfolio by concentrating 30% of exposure to the top 10 borrowers.
    * *Result:* "Fat Tail" risk increased significantly, proving the danger of low granularity.
* **Model 5: Multi-Factor Sectoral Model**
    * Uses **Cholesky Decomposition** to model correlations between different industrial sectors.
    * *Optimization:* Sectoral diversification reduced Capital Reserve requirements by **~30%**.

## 📊 Technical Metrics
The software calculates the following core risk metrics for each simulation:
* **EL (Expected Loss):** The anticipated average loss.
* **VaR (Value-at-Risk):** The threshold loss at a 99.9% confidence level (Basel III standard).
* **ES (Expected Shortfall):** The average loss in extreme tail events (Conditional VaR).
* **UL (Unexpected Loss):** The capital buffer required (`VaR - EL`).

## 📂 Project Structure
```text
Basel-III-Credit-Risk-Engine/
├── src/                  # Source Code (MATLAB .m files)
│   ├── main.m            # Central controller and simulation logic
│   ├── parameters.m      # Portfolio limits (EAD, PD, LGD) and settings
│   └── fmodel_X.m        # Mathematical implementations of Models 1-5
├── docs/                 # Documentation
│   └── Credit_Portfolio_Risk_Analysis_Report.pdf  # Full Technical Report of my Term Project which I kept it
└── README.md             