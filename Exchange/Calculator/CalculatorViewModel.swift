//
//  CalculatorViewModel.swift
//  Exchange
//
//  Created by Imron Mirzarasulov on 03/03/26.
//

import Foundation

struct CalculatorViewState {
    var fromCurrency: Currency
    var toCurrency: Currency
    var fromAmount: Double
    var toAmount: Double
    var exchangeRate: ExchangeRate?
    var activeField: ActiveField
}

protocol CalculatorViewModelProtocol {
    var state: CalculatorViewState { get set }
    func fetchExchangeRate() async
    func updateAmount(_ amount: String, for field: ActiveField)
    var onError: (() -> Void)? { get set }
    var onStateChanged: (() -> Void)? { get set }
    func currentToCurrencyIndex() -> Int
    func swapCards()
}

final class CalculatorViewModel: CalculatorViewModelProtocol {
    var state: CalculatorViewState
    var onError: (() -> Void)?
    var onStateChanged: (() -> Void)?
    
    // Получить индекс активного cell
    func currentToCurrencyIndex() -> Int {
        let currencies = DataStore.shared.currencies
        return currencies.firstIndex {$0.name == state.toCurrency.name && $0.icon == state.toCurrency.icon} ?? 0
    }
    
    // Обновляем значение стейтов которые отвечают за textfield, устанавливаем активный textfield и отправляем сигнал об изменении
    func updateAmount(_ amount: String, for field: ActiveField) {
        switch field {
        case .from:
            self.state.fromAmount = Double(amount) ?? 0
            self.state.toAmount = (Double(amount) ?? 0) * (self.state.exchangeRate?.ask ?? 0)
            self.state.activeField = .from
            onStateChanged?()
        case .to:
            self.state.toAmount = Double(amount) ?? 0
            self.state.fromAmount = (Double(amount) ?? 0) / (self.state.exchangeRate?.bid ?? 0)
            self.state.activeField = .to
            onStateChanged?()
        }
    }
    
    func swapCards() {
        
    }
    
    // Получить курс текущей валюты
    func fetchExchangeRate() async {
        let api = "https://api.dolarapp.dev/v1/tickers?currencies=\(state.toCurrency.name.uppercased())"
        guard let url = URL(string: api) else {
            print("Invalid URL")
            return
        }
        
        do {
            self.state.exchangeRate = try await NetworkManager.shared.fetch([ExchangeRate].self, from: url)[0]
        } catch {
            onError?()
            self.state.exchangeRate = (
                try? NetworkManager.shared.fetchMockExchangeRate()
            )?[0] ?? ExchangeRate(ask: 1454.5, bid: 1455.5, book: "usdc_ars", date: "2026-07-03")
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
            activeField: .from
        )
    }
}
