//
//  GlobalMarketData.swift
//  CryptoApp
//
//  Created by Rohan Prakash on 22/08/24.


import Foundation

struct GlobalMarketData: Codable {
    let data: MarketDataDetails

    struct MarketDataDetails: Codable {
        let totalMarketCap: [String: Double]
        let totalVolume: [String: Double]
        
        enum CodingKeys: String, CodingKey {
            case totalMarketCap = "total_market_cap"
            case totalVolume = "total_volume"
        }
        
        enum CurrencyCodingKeys: String, CodingKey {
            case usd
        }
        
        var marketCapUSD: Double {
            totalMarketCap["usd"] ?? 0
        }
        
        var totalVolumeUSD: Double {
            totalVolume["usd"] ?? 0
        }
    }
}


