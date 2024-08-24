import SwiftUI

struct CryptoDetailView: View {
    var crypto: MarketData

    @Environment(\.dismiss) private var dismiss

    @State private var priceHistory: [Double] = []
    @State private var marketCap: Double = 0
    @State private var volume24h: Double = 0
    @State private var isLoading: Bool = true
    @State private var currentCryptoId: String = ""

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    CircleButton(iconName: "xmark")
                       
                }
                .padding(.trailing)
            }

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

                if !priceHistory.isEmpty {
                    PriceLineGraphView(prices: priceHistory)
                        .frame(height: 200)
                        .padding()
                } else {
                    Text("Failed to load graph data.")
                        .foregroundColor(.red)
                        .padding()
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text("Overview")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.red)
                        .padding(.bottom, 8)

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Price")
                                .font(.subheadline)
                                .foregroundColor(Color.theme.accent)
                            Text("\(formatNumber(crypto.current_price)) USD")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                        }
                        Spacer()
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(Color.theme.green)
                            .font(.system(size: 32))
                    }

                    Divider()
                        .background(Color.theme.accent)
                        .padding(.vertical, 8)

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Market Cap")
                                .font(.subheadline)
                                .foregroundColor(Color.theme.accent)
                            Text("\(formatNumber(marketCap)) USD")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                        }
                        Spacer()
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(Color.theme.green)
                            .font(.system(size: 32))
                    }

                    Divider()
                        .background(Color.theme.accent)
                        .padding(.vertical, 8)

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("24h Volume")
                                .font(.subheadline)
                                .foregroundColor(Color.theme.accent)
                            Text("\(formatNumber(volume24h)) USD")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                        }
                        Spacer()
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundColor(Color.blue)
                            .font(.system(size: 32))
                    }
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(10)
                .shadow(radius: 5)
            }
        }
        .onAppear {
            loadData()
        }
        .onChange(of: crypto.id) { newId in
            print("Crypto ID changed to \(newId)")
            loadData()
        }
    }

    func loadData() {
        // Reset states before fetching new data
        print("Loading data for \(crypto.id)")
        priceHistory = []
        marketCap = 0
        volume24h = 0
        isLoading = true
        currentCryptoId = crypto.id

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
            print("Finished loading data for \(self.crypto.id)")
            if currentCryptoId == crypto.id {
                isLoading = false
            }
        }
    }

    func fetchPriceHistory(completion: @escaping () -> Void) {
        let historyURL = URL(string: "https://api.coingecko.com/api/v3/coins/\(crypto.id)/market_chart?vs_currency=usd&days=7")!
        NetworkManager.shared.fetch(url: historyURL) { (result: Result<PriceHistoryResponse, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print("Price history fetched successfully for \(self.crypto.id)")
                    if currentCryptoId == crypto.id && !response.prices.isEmpty {
                        priceHistory = response.prices.map { $0[1] }
                    }
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
                    print("Coin details fetched successfully for \(self.crypto.id)")
                    if currentCryptoId == crypto.id {
                        marketCap = response.market_data.market_cap.usd
                        volume24h = response.market_data.total_volume.usd
                    }
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
