//
//  CoinModel.swift
//  CryptoApp
//
//  Created by Rohan Prakash on 22/08/24.
//



import Foundation

struct MarketData: Codable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    let current_price: Double
    let price_change_percentage_24h: Double
    let image: String

    // Conform to Identifiable for use in List
    //var id: String { id }
}




