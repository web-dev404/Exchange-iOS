//
//  CurrencyCardViewModel.swift
//  Exchange
//
//  Created by Imron Mirzarasulov on 05/03/26.
//

import Foundation

protocol CurrencyCardViewModelProtocol {
    var currencyIcon: String { get }
    var currencyName: String { get }
    var amount: String { get }
    var isChangeable: Bool { get }
}

final class CurrencyCardViewModel: CurrencyCardViewModelProtocol {
    private let currency: Currency

    var currencyIcon: String {
        currency.icon
    }
    
    var currencyName: String {
        currency.name
    }
    
    var amount: String
    
    var isChangeable: Bool
    
    init(currency: Currency, amount: String = "", isChangeable: Bool = false) {
        self.currency = currency
        self.amount = amount
        self.isChangeable = isChangeable
    }
}
