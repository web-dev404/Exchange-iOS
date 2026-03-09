//
//  CurrencyCellViewModel.swift
//  Exchange
//
//  Created by Imron Mirzarasulov on 05/03/26.
//

import Foundation

protocol CurrencyCellViewModelProtocol {
    var currencyName: String { get }
    var currencyIcon: String { get }
    var isSelected: Bool { get set }
    
    init(currency: Currency, isSelected: Bool)
}

final class CurrencyCellViewModel: CurrencyCellViewModelProtocol {
    var isSelected: Bool
    
    var currencyName: String {
        currency.name
    }
    
    var currencyIcon: String {
        currency.icon
    }
    
    private let currency: Currency
    
    required init(currency: Currency, isSelected: Bool) {
        self.currency = currency
        self.isSelected = isSelected
    }
}
