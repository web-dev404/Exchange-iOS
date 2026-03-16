//
//  CalculatorViewModel.swift
//  Exchange
//
//  Created by Imron Mirzarasulov on 03/03/26.
//

import Foundation

enum ActiveField {
    case from
    case to
}
enum ActiveCard {
    case from
    case to
}

struct CalculatorViewState {
    var fromCurrency: Currency
    var toCurrency: Currency
    var fromAmount: Double
    var toAmount: Double
    var exchangeRate: ExchangeRate?
    var activeField: ActiveField
    var activeCard: ActiveCard
}

protocol CalculatorViewModelProtocol {
    var state: CalculatorViewState { get set }
    var onError: (() -> Void)? { get set }
    var onAmountChanged: (() -> Void)? { get set }
    var onSwapTapped: (() -> Void)? { get set }
    
    func currentToCurrencyIndex() -> Int
    func updateAmount(_ amount: String, for field: ActiveField)
    func swapCards()
    func fetchExchangeRate() async
}

final class CalculatorViewModel: CalculatorViewModelProtocol {
    var state: CalculatorViewState
    var onError: (() -> Void)?
    var onAmountChanged: (() -> Void)?
    var onSwapTapped: (() -> Void)?
    
    // Получить индекс активного cell
    func currentToCurrencyIndex() -> Int {
        let currencies = DataStore.shared.currencies
        let currentCurrency = state.activeCard == .from ? state.fromCurrency.name : state.toCurrency.name
        
        return currencies.firstIndex {$0.name == currentCurrency} ?? 0
    }
    
    // Обновляем значение стейтов которые отвечают за textfield, устанавливаем активный textfield и отправляем сигнал об изменении
    func updateAmount(_ amount: String, for field: ActiveField) {
        switch field {
        case .from:
            self.state.fromAmount = Double(amount) ?? 0
            self.state.activeField = .from
            
            if state.fromCurrency.name == "USDc" {
                self.state.toAmount = (Double(amount) ?? 0) * (self.state.exchangeRate?.ask ?? 0)
            } else {
                self.state.toAmount = (Double(amount) ?? 0) / (self.state.exchangeRate?.bid ?? 0)
            }
        case .to:
            self.state.toAmount = Double(amount) ?? 0
            self.state.activeField = .to
            
            if state.toCurrency.name == "USDc" {
                self.state.fromAmount = (Double(amount) ?? 0) * (self.state.exchangeRate?.ask ?? 0)
            } else {
                self.state.fromAmount = (Double(amount) ?? 0) / (self.state.exchangeRate?.bid ?? 0)
            }
        }
        
        onAmountChanged?()
    }
    
    func swapCards() {
        let tempCurrency = state.fromCurrency
        state.fromCurrency = state.toCurrency
        state.toCurrency = tempCurrency
        
        let tempAmount = state.fromAmount
        state.fromAmount = state.toAmount
        state.toAmount = tempAmount
        
        onSwapTapped?()
    }
    
    // Получить курс текущей валюты
    func fetchExchangeRate() async {
        let currencyName = state.fromCurrency.name != "USDc" ? state.fromCurrency.name.uppercased() : state.toCurrency.name.uppercased()
        let api = "https://api.dolarapp.dev/v1/tickers?currencies=\(currencyName)"
        guard let url = URL(string: api) else {
            print("Invalid URL")
            return
        }
        
        do {
            self.state.exchangeRate = try await NetworkManager.shared.fetch([ExchangeRate].self, from: url)[0]
        } catch {
            self.state.exchangeRate = (
                try? NetworkManager.shared.fetchMockExchangeRate()
            )?[0] ?? ExchangeRate(ask: 1454.5, bid: 1455.5, book: "usdc_ars", date: "2026-07-03")
            onError?()
        }
    }
    
    init() {
        let currencies = DataStore.shared.currencies
        
        self.state = CalculatorViewState(
            fromCurrency: Currency(name: "USDc", icon: "us"),
            toCurrency: currencies[0],
            fromAmount: 0,
            toAmount: 0,
            exchangeRate: nil,
            activeField: .from,
            activeCard: .to
        )
    }
}
