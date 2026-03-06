//
//  CalculatorViewModel.swift
//  Exchange
//
//  Created by Imron Mirzarasulov on 03/03/26.
//

import Foundation

protocol CalculatorViewModelProtocol {
    var fromCurrency: Currency { get }
    var toCurrency: Currency { get }
    var fromAmount: Double { get }
    var toAmount: Double { get }
}
