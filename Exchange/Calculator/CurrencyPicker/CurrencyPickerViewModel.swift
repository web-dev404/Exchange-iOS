//
//  CurrencyPickerViewModel.swift
//  Exchange
//
//  Created by Imron Mirzarasulov on 04/03/26.
//

import Foundation

protocol CurrencyPickerViewModelProtocol {
    func numberOfRows() -> Int
    func getCurrencyCellViewModel(at indexPath: Int, activeIndex: Int) -> CurrencyCellViewModelProtocol
    func getCurrencies(completion: @escaping() -> Void)
    func getCurrency(by indexPath: Int) -> Currency
}

final class CurrencyPickerViewModel: CurrencyPickerViewModelProtocol {
    private var currencies: [Currency] = []
    
    func numberOfRows() -> Int {
        currencies.count
    }
    
    func getCurrencyCellViewModel(at indexPath: Int, activeIndex: Int) -> any CurrencyCellViewModelProtocol {
        CurrencyCellViewModel(currency: currencies[indexPath], isSelected: indexPath == activeIndex ? true : false)
    }
    
    func getCurrencies(completion: @escaping () -> Void) {
        currencies = DataStore.shared.currencies
        completion()
    }
    
    func getCurrency(by indexPath: Int) -> Currency {
        currencies[indexPath]
    }
}
