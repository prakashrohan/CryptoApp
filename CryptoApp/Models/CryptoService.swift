//
//  CryptoService.swift
//  CryptoApp
//
//  Created by Rohan Prakash on 22/08/24.
//

import Foundation


func fetchMarketData(completion: @escaping ([MarketData]?) -> Void) {
    let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd")!
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let marketData = try decoder.decode([MarketData].self, from: data)
            completion(marketData)
        } catch {
            completion(nil)
        }
    }
    task.resume()
}





