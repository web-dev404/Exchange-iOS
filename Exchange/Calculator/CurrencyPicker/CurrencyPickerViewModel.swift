//
//  CurrencyPickerViewModel.swift
//  Exchange
//
//  Created by Imron Mirzarasulov on 04/03/26.
//

import Foundation

protocol CurrencyPickerViewModelProtocol {
    func numberOfRows() -> Int
    func getCurrencyCellViewModel(at indexPath: Int) -> CurrencyCellViewModelProtocol
    func getCurrencies(completion: @escaping() -> Void)
}

final class CurrencyPickerViewModel: CurrencyPickerViewModelProtocol {
    private var currencies: [Currency] = []
    
    func numberOfRows() -> Int {
        currencies.count
    }
    
    func getCurrencyCellViewModel(at indexPath: Int) -> any CurrencyCellViewModelProtocol {
        CurrencyCellViewModel(currency: currencies[indexPath], isSelected: true)
    }
    
    func getCurrencies(completion: @escaping () -> Void) {
        currencies = DataStore.shared.currencies
        completion()
    }
}
