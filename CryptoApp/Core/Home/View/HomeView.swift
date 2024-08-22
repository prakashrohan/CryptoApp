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

    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()

            VStack {
                homeHeader

                if !showPortfolio {
                    if !isSearching, let globalData = globalMarketData {
                        marketInfo(globalData: globalData)
                            .transition(.opacity)
                            .animation(.easeOut(duration: 0.3))
                    }
                }
                
                searchBar
                
                cryptolist
                
                Spacer(minLength: 0)
            }
            .onAppear {
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
            .gesture(
                TapGesture()
                    .onEnded { _ in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isSearching = false
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }
            )
            .fullScreenCover(isPresented: $showPortfolio) {
                PortfolioView(portfolio: $portfolio)
            }
        }
    }
}

extension HomeView {
    
    private var homeHeader: some View {
        HStack {
            CircleButton(iconName: showAddCryptoOptions ? "line.3.horizontal" : "plus")
                .onTapGesture {
                    withAnimation(.spring()) {
                        if showPortfolio {
                            // Handle info button tap when in portfolio mode
                        } else {
                            showAddCryptoOptions.toggle()
                        }
                    }
                }
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
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

    
    private func marketInfo(globalData: GlobalMarketData) -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text("Market Info")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.theme.red)
            HStack {
                Text("Market Cap:")
                    .font(.title3)
                    .foregroundColor(Color.theme.accent)
                Text("\(formatNumber(globalData.data.marketCapUSD)) USD")
                    .font(.title3)
                    .foregroundColor(.primary)
            }
            HStack {
                Text("24h Trading Volume:")
                    .font(.title3)
                    .foregroundColor(Color.theme.accent)
                Text("\(formatNumber(globalData.data.totalVolumeUSD)) USD")
                    .font(.title3)
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
    private var searchBar: some View {
        TextField("Search...", text: $searchText, onEditingChanged: { isEditing in
            withAnimation(.easeInOut(duration: 0.3)) {
                isSearching = isEditing
            }
        })
        .font(.subheadline)
        .foregroundColor(Color.theme.accent)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal)
    }

    private var cryptolist: some View {
        ZStack {
            VStack {
                if let data = marketData {
                    List(filteredCryptos) { item in
                        HStack {
                            if showAddCryptoOptions {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 40)
                                    .foregroundColor(Color.blue)
                                    .scaleEffect(tappedCryptoId == item.id ? 1.2 : 1.0) // Scale effect
                                    .opacity(tappedCryptoId == item.id ? 0.5 : 1.0) // Opacity effect
                                    .animation(.easeInOut(duration: 0.2), value: tappedCryptoId)
                                    .onTapGesture {
                                        tappedCryptoId = item.id
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            if !portfolio.contains(where: { $0.id == item.id }) {
                                                portfolio.append(item)
                                            }
                                            tappedCryptoId = nil
                                        }
                                    }
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

func formatNumber(_ number: Double) -> String {
    switch number {
    case 1_000_000_000_000...:
        return String(format: "%.2fT", number / 1_000_000_000_000) // Trillions
    case 1_000_000_000...:
        return String(format: "%.2fB", number / 1_000_000_000) // Billions
    case 1_000_000...:
        return String(format: "%.2fM", number / 1_000_000) // Millions
    case 1_000...:
        return String(format: "%.2fK", number / 1_000) // Thousands
    default:
        return String(format: "%.2f", number) // Less than 1000
    }
}

#Preview {
    HomeView()
}
