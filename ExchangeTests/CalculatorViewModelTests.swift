//
//  CalculatorViewModelTests.swift
//  ExchangeTests
//
//  Created by Imron Mirzarasulov on 15/03/26.
//

import XCTest
@testable import Exchange

final class CalculatorViewModelTests: XCTestCase {
    var calculator: CalculatorViewModel!

    override func setUp() {
        super.setUp()
        calculator = CalculatorViewModel()
    }

    override func tearDown() {
        calculator = nil
        super.tearDown()
    }

    func testUpdateAmountShouldMultiplyWhenFromCurrencyIsUSDc() {
        calculator.state.exchangeRate = ExchangeRate(ask: 1000, bid: 1000, book: "usdc_ars", date: "2026-01-01")
        calculator.updateAmount("2", for: .from)
        XCTAssertEqual(calculator.state.toAmount, 2000)
    }
    
    func testUpdateAmountShouldMultiplyWhenToCurrencyIsUSDc() {
        calculator.state.exchangeRate = ExchangeRate(ask: 1000, bid: 1000, book: "usdc_ars", date: "2026-01-01")
        calculator.state.toCurrency = Currency(name: "USDc", icon: "us")
        calculator.updateAmount("2", for: .to)
        XCTAssertEqual(calculator.state.fromAmount, 2000)
    }
    
    func testUpdateAmountShouldReturn0WhenStringIsEmpty() {
        calculator.updateAmount("", for: .from)
        XCTAssertEqual(calculator.state.toAmount, 0)
    }
    
    func testUpdateAmountShouldReturn0WhenStringIs0() {
        calculator.updateAmount("0", for: .from)
        XCTAssertEqual(calculator.state.toAmount, 0)
    }
    
    func testUpdateAmountShouldReturn0WhenExchangeRateIsNil() {
        calculator.state.exchangeRate = nil
        calculator.updateAmount("2", for: .from)
        XCTAssertEqual(calculator.state.toAmount, 0)
    }
}
