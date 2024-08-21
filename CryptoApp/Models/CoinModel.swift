//
//  CoinModel.swift
//  CryptoApp
//
//  Created by Rohan Prakash on 22/08/24.
//

import Foundation

struct CryptoCurrency: Identifiable, Codable {
    let id: String
    let name: String
    let symbol: String
    let image: String
    let current_price: Double

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case image
        case current_price = "current_price"
    }
}
