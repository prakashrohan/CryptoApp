import SwiftUI

struct CryptoDetailView: View {
    var crypto: MarketData

    @Environment(\.dismiss) private var dismiss

    @State private var priceHistory: [Double] = []
    @State private var marketCap: Double = 0
    @State private var volume24h: Double = 0
    @State private var priceChangePercentage24h: Double = 0
    @State private var isLoading: Bool = true
    @State private var currentCryptoId: String = ""

    var body: some View {
        VStack {
            header
            if isLoading {
                loadingView
            } else {
                contentView
            }
        }
        .onAppear { loadData() }
        .onChange(of: crypto.id) { _ in loadData() }
    }

    private var header: some View {
        HStack {
            Spacer()
            Button(action: { dismiss() }) {
                CircleButton(iconName: "xmark")
            }
            .padding(.trailing)
        }
    }

    private var loadingView: some View {
        ProgressView("Loading...")
            .padding()
    }

    private var contentView: some View {
        VStack {
            cryptoInfo
            graphSection
            overviewSection
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }

    private var cryptoInfo: some View {
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
    }

    private var graphSection: some View {
        Group {
            if !priceHistory.isEmpty {
                PriceLineGraphView(prices: priceHistory)
                    .frame(height: 200)
                    .padding()
            } else {
                Text("Failed to load graph data.")
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }


    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.red)
                .padding(.bottom, 8)
            
            overviewRow(title: "Price", value: crypto.current_price, icon: "dollarsign.circle.fill", color: .yellow)
            overviewRow(title: "Market Cap", value: marketCap, icon: "chart.bar.fill", color: Color.theme.green)
            overviewRow(title: "24h Volume", value: volume24h, icon: "arrow.up.arrow.down", color: .blue)
        }
    }

    private func overviewRow(title: String, value: Double, icon: String, color: Color) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(Color.theme.accent)
                Text("\(formatNumber(value)) USD")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(priceChangePercentage24h >= 0 ? Color.theme.green : Color.red)
            }
            Spacer()
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 32))
        }
        .padding(.vertical, 8)
    }

    private func loadData() {
        print("Loading data for \(crypto.id)")
        resetState()
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

    private func resetState() {
        priceHistory = []
        marketCap = 0
        volume24h = 0
        priceChangePercentage24h = 0
        isLoading = true
    }

    private func fetchPriceHistory(completion: @escaping () -> Void) {
        let historyURL = URL(string: "https://api.coingecko.com/api/v3/coins/\(crypto.id)/market_chart?vs_currency=usd&days=7")!
        NetworkManager.shared.fetch(url: historyURL) { (result: Result<PriceHistoryResponse, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
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

    private func fetchCoinDetails(completion: @escaping () -> Void) {
        let detailsURL = URL(string: "https://api.coingecko.com/api/v3/coins/\(crypto.id)")!
        NetworkManager.shared.fetch(url: detailsURL) { (result: Result<CoinDetailsResponse, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if currentCryptoId == crypto.id {
                        marketCap = response.market_data.market_cap.usd
                        volume24h = response.market_data.total_volume.usd
                        priceChangePercentage24h = response.market_data.price_change_percentage_24h ?? 0
                    }
                }
            case .failure(let error):
                print("Failed to fetch coin details: \(error)")
            }
            completion()
        }
    }
}
