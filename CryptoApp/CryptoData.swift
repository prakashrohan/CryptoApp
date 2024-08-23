//
//  CryptoData.swift
//  CryptoApp
//
//  Created by Rohan Prakash on 23/08/24.
//

import Foundation

func fetchCryptoData(coinId: String, completion: @escaping (MarketData?) -> Void) {
    let urlString = "https://api.coingecko.com/api/v3/coins/\(coinId)"
    
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }
        
        do {
            let decodedData = try JSONDecoder().decode(MarketData.self, from: data)
            completion(decodedData)
        } catch {
            completion(nil)
        }
    }.resume()
}

