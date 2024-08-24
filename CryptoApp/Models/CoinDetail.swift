//
//  CoinDetail.swift
//  CryptoApp
//
//  Created by Rohan Prakash on 24/08/24.
//

import Foundation

struct PriceHistoryResponse: Decodable {
    let prices: [[Double]]
}
struct CoinDetailsResponse: Decodable {
    let market_data: MarketDataDetails
    
    struct MarketDataDetails: Decodable {
        let market_cap: MarketCap
        let total_volume: Volume
        let price_change_percentage_24h: Double?
        
        struct MarketCap: Decodable {
            let usd: Double
        }
        
        struct Volume: Decodable {
            let usd: Double
        }
    }
}
