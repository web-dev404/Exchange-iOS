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
}

protocol CalculatorViewModelProtocol {
    var state: CalculatorViewState { get set }
    func fetchExchangeRate() async
    var onError: (() -> Void)? { get set }
}

final class CalculatorViewModel: CalculatorViewModelProtocol {
    var state: CalculatorViewState
    private let api = "https://api.dolarapp.dev/v1/tickers?currencies=ARS"
    
    var onError: (() -> Void)?
    
    func fetchExchangeRate() async {
        guard state.exchangeRate == nil else {
            return
        }
        
        guard let url = URL(string: api) else {
            print("Invalid URL")
            return
        }
        
        do {
            self.state.exchangeRate = try await NetworkManager.shared.fetchExchangeRate([ExchangeRate].self, from: url)[0]
        } catch {
            onError?()
            self.state.exchangeRate = (try? NetworkManager.shared.fetchMockExchangeRate())?[0] ?? ExchangeRate(ask: 1454.5, bid: 1455.5, book: "usdc_ars", date: "2026-07-03")
        }
    }
    
    init() {
        let currencies = DataStore.shared.currencies
        
        self.state = CalculatorViewState(fromCurrency: Currency(name: "USDc", icon: "us"), toCurrency: currencies[0], fromAmount: 0, toAmount: 0, exchangeRate: nil)
    }
}
