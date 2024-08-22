//
//  CryptoService.swift
//  CryptoApp
//
//  Created by Rohan Prakash on 22/08/24.
//

import Foundation

class CryptoService {
    func fetchCryptos(completion: @escaping ([CryptoCurrency]) -> Void) {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let cryptos = try? decoder.decode([CryptoCurrency].self, from: data) {
                    DispatchQueue.main.async {
                        completion(cryptos)
                    }
                }
            }
        }.resume()
    }
    
    
}

