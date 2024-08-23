import SwiftUI

struct CryptoDetailView: View {
    var crypto: MarketData
    
    @State private var priceHistory: [Double] = []
    @State private var marketCap: Double = 0
    @State private var volume24h: Double = 0
    @State private var isLoading: Bool = true
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
                    .padding()
            } else {
                HStack {
                    if let imageUrl = URL(string: crypto.image) {
                        AsyncImage(url: imageUrl) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    
                    Text(crypto.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .padding()
                
                PriceLineGraphView(prices: priceHistory)
                    .frame(height: 200)
                    .padding()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Price: \(crypto.current_price, specifier: "%.2f") USD")
                        .font(.headline)
                    Text("Market Cap: \(formatNumber(marketCap)) USD")
                        .font(.subheadline)
                    Text("24h Volume: \(formatNumber(volume24h)) USD")
                        .font(.subheadline)
                }
                .padding()
            }
        }
        .onAppear {
            fetchDataInParallel()
        }
    }
    
    func fetchDataInParallel() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchPriceHistory {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchCoinDetails {
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            isLoading = false
        }
    }
    
    func fetchPriceHistory(completion: @escaping () -> Void) {
        let historyURL = URL(string: "https://api.coingecko.com/api/v3/coins/\(crypto.id)/market_chart?vs_currency=usd&days=7")!
        NetworkManager.shared.fetch(url: historyURL) { (result: Result<PriceHistoryResponse, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    priceHistory = response.prices.map { $0[1] }
                }
            case .failure(let error):
                print("Failed to fetch price history: \(error)")
            }
            completion()
        }
    }
    
    func fetchCoinDetails(completion: @escaping () -> Void) {
        let detailsURL = URL(string: "https://api.coingecko.com/api/v3/coins/\(crypto.id)")!
        NetworkManager.shared.fetch(url: detailsURL) { (result: Result<CoinDetailsResponse, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    marketCap = response.market_data.market_cap.usd
                    volume24h = response.market_data.total_volume.usd
                }
            case .failure(let error):
                print("Failed to fetch coin details: \(error)")
            }
            completion()
        }
    }
}

// Structs for decoding API responses

struct PriceHistoryResponse: Decodable {
    let prices: [[Double]]
}

struct CoinDetailsResponse: Decodable {
    let market_data: MarketDataDetails
    
    struct MarketDataDetails: Decodable {
        let market_cap: MarketCap
        let total_volume: Volume
        
        struct MarketCap: Decodable {
            let usd: Double
        }
        
        struct Volume: Decodable {
            let usd: Double
        }
    }
}
