//
//  MarketDataService.swift
//  CryptoApp
//
//  Created by Rohan Prakash on 22/08/24.
//

import Foundation



func fetchGlobalMarketData(completion: @escaping (GlobalMarketData?) -> Void) {
    guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {
        completion(nil)
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            print("Error fetching global market data: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
            return
        }
        do {
            let globalData = try JSONDecoder().decode(GlobalMarketData.self, from: data)
            print("Global market data fetched: \(globalData)")
            completion(globalData)
        } catch {
            print("Error decoding global market data: \(error.localizedDescription)")
            completion(nil)
        }
    }.resume()
}

