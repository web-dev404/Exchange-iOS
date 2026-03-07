//
//  CalculatorViewModel.swift
//  Exchange
//
//  Created by Imron Mirzarasulov on 03/03/26.
//

import Foundation

struct CalculatorViewState {
    var fromCurrency: Currency
    let toCurrency: Currency
    let fromAmount: Double
    let toAmount: Double
    let exchangeRate: ExchangeRate?
}

protocol CalculatorViewModelProtocol {
    var state: CalculatorViewState { get }
}

final class CalculatorViewModel: CalculatorViewModelProtocol {
    var state: CalculatorViewState
    
    init() {
        let currencies = DataStore.shared.currencies
        
        self.state = CalculatorViewState(fromCurrency: Currency(name: "USDc", icon: "us"), toCurrency: currencies[0], fromAmount: 0, toAmount: 0, exchangeRate: nil)
    }
}
