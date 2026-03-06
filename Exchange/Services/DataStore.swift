//
//  DataStore.swift
//  Exchange
//
//  Created by Imron Mirzarasulov on 04/03/26.
//

import Foundation

final class DataStore {
    static let shared = DataStore()
        
    private init() {}
    
    let currencies: [Currency] = [
        Currency(name: "ARS", icon: "ars"),
        Currency(name: "EURc", icon: "eur"),
        Currency(name: "COP", icon: "cop"),
        Currency(name: "MXN", icon: "mxn"),
        Currency(name: "BRL", icon: "brl"),
    ]
}
