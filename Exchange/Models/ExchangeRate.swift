//
//  ExchangeRate.swift
//  Exchange
//
//  Created by Imron Mirzarasulov on 04/03/26.
//

import Foundation

struct ExchangeRate: Decodable {
    let ask: Double
    let bid: Double
    let book: String
    let date: String
    
    enum CodingKeys: CodingKey {
        case ask
        case bid
        case book
        case date
    }
    
    init(ask: Double, bid: Double, book: String, date: String) {
        self.ask = ask
        self.bid = bid
        self.book = book
        self.date = date
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ask = Double(try container.decode(String.self, forKey: .ask)) ?? 0
        self.bid = Double(try container.decode(String.self, forKey: .bid)) ?? 0
        self.book = try container.decode(String.self, forKey: .book)
        self.date = try container.decode(String.self, forKey: .date)
    }
}
