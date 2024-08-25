import SwiftUI

struct HomeView: View {

    @State private var marketData: [MarketData]?
    @State private var globalMarketData: GlobalMarketData?
    @State private var showPortfolio: Bool = false
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    @State private var showAddCryptoOptions: Bool = false
    @State private var portfolio: [MarketData] = []
    @State private var tappedCryptoId: String? = nil
    @State private var selectedCrypto: MarketData? = nil

    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                homeHeader
                if !showPortfolio && !isSearching {
                    marketInfoView
                }
                searchBar
                cryptoListView
                Spacer(minLength: 0)
            }
            .onAppear(perform: loadData)
            .gesture(tapGesture)
            .fullScreenCover(isPresented: $showPortfolio) {
                PortfolioView(portfolio: $portfolio)
            }
        }
    }
}

// MARK: - Components

extension HomeView {
    
    private var homeHeader: some View {
        HStack {
            CircleButton(iconName: showAddCryptoOptions ? "line.3.horizontal" : "plus")
                .onTapGesture {
                    withAnimation(.spring()) {
                        showAddCryptoOptions.toggle()
                        if showPortfolio {
                            
                        }
                    }
                }
            Spacer()
            Text("Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accent)
            Spacer()
            CircleButton(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }

    private var marketInfoView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Market Info")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.red)
                .padding(.bottom, 8)
            
            marketInfoRow(title: "Market Cap", value: globalMarketData?.data.marketCapUSD ?? 0, icon: "chart.bar.fill", color: Color.theme.green)
            marketInfoRow(title: "24h Trading Volume", value: globalMarketData?.data.totalVolumeUSD ?? 0, icon: "arrow.up.arrow.down", color: Color.blue)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.background)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
    
    private func marketInfoRow(title: String, value: Double, icon: String, color: Color) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(Color.theme.accent)
                Text("\(formatNumber(value)) USD")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            Spacer()
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 32))
        }
    }
    
    private var searchBar: some View {
        HStack {
            if !isSearching {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.theme.accent)
                    .transition(.opacity)  // Smooth transition
                    .animation(.easeInOut(duration: 0.3), value: isSearching)
            }
            TextField("Search...", text: $searchText, onEditingChanged: { isEditing in
                withAnimation(.easeInOut(duration: 0.3)) {
                    isSearching = isEditing
                }
            })
            .font(.subheadline)
            .foregroundColor(Color.theme.accent)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal)
    }
    
    private var cryptoListView: some View {
        ZStack {
            VStack {
                if let marketData = marketData {
                    if filteredCryptos.isEmpty {

                        NotFound()
                    } else {
                        List(filteredCryptos) { item in
                            cryptoListItemView(item: item)
                                .onTapGesture {
                                    selectedCrypto = item
                                }
                        }
                    }
                } else {
                    ProgressView()
                        .onAppear {
                            fetchMarketData { data in
                                DispatchQueue.main.async {
                                    self.marketData = data
                                }
                            }
                        }
                }
            }
        }
        .sheet(item: $selectedCrypto) { crypto in
            CryptoDetailView(crypto: crypto)
        }
    }

    
    private func cryptoListItemView(item: MarketData) -> some View {
        HStack {
            if showAddCryptoOptions {
                cryptoActionIcon(item: item)
            } else {
                AsyncImage(url: URL(string: item.image)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                } placeholder: {
                    ProgressView()
                }
            }
            Text(item.name)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
                .fontWeight(.bold)
            Spacer()
            Text("\(item.current_price, specifier: "%.2f") USD")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(item.price_change_percentage_24h >= 0 ? .green : .red)
        }
        .contentShape(Rectangle())
    }
    
    private func cryptoActionIcon(item: MarketData) -> some View {
        ZStack {
            let isCryptoInPortfolio = portfolio.contains(where: { $0.id == item.id })
            
            Image(systemName: isCryptoInPortfolio || tappedCryptoId == item.id ? "checkmark.circle.fill" : "plus.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 40)
                .foregroundColor(isCryptoInPortfolio || tappedCryptoId == item.id ? .green : .blue)
                .scaleEffect(tappedCryptoId == item.id ? 1.2 : 1.0)
                .opacity(tappedCryptoId == item.id ? 0.5 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: tappedCryptoId)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        tappedCryptoId = item.id
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        if isCryptoInPortfolio {
                            portfolio.removeAll { $0.id == item.id }
                        } else {
                            portfolio.append(item)
                        }
                        tappedCryptoId = nil
                    }
                }
        }
    }
}

// MARK: - Data Loading and Filtering

extension HomeView {

    private func loadData() {
        fetchGlobalMarketData { data in
            DispatchQueue.main.async {
                self.globalMarketData = data
            }
        }
        fetchMarketData { data in
            DispatchQueue.main.async {
                self.marketData = data
            }
        }
    }

    private var filteredCryptos: [MarketData] {
        guard let data = marketData else { return [] }
        let searchLowercased = searchText.lowercased()
        return data.filter { item in
            searchText.isEmpty ||
            item.name.lowercased().contains(searchLowercased) ||
            item.symbol.lowercased().contains(searchLowercased)
        }
    }
}

// MARK: - Helpers

func formatNumber(_ number: Double) -> String {
    switch number {
    case 1_000_000_000_000...:
        return String(format: "%.2fT", number / 1_000_000_000_000)
    case 1_000_000_000...:
        return String(format: "%.2fB", number / 1_000_000_000)
    case 1_000_000...:
        return String(format: "%.2fM", number / 1_000_000)
    case 1_000...:
        return String(format: "%.2fK", number / 1_000)
    default:
        return String(format: "%.2f", number)
    }
}


// MARK: - Gestures

extension HomeView {

    private var tapGesture: some Gesture {
        TapGesture()
            .onEnded { _ in
                withAnimation(.easeInOut(duration: 0.3)) {
                    isSearching = false
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
    }
}

#Preview {
    HomeView()
}
