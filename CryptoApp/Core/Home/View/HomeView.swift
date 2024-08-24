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
                loadData()
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

    private func marketInfo(globalData: GlobalMarketData) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Market Info")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.red)
                .padding(.bottom, 8)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Market Cap")
                        .font(.subheadline)
                        .foregroundColor(Color.theme.accent)
                    Text("\(formatNumber(globalData.data.marketCapUSD)) USD")
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
                    Text("24h Trading Volume")
                        .font(.subheadline)
                        .foregroundColor(Color.theme.accent)
                    Text("\(formatNumber(globalData.data.totalVolumeUSD)) USD")
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
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.background)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
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
                if marketData != nil {
                    List(filteredCryptos) { item in
                        HStack {
                            if showAddCryptoOptions {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 40)
                                    .foregroundColor(Color.blue)
                                    .scaleEffect(tappedCryptoId == item.id ? 1.2 : 1.0)
                                    .opacity(tappedCryptoId == item.id ? 0.5 : 1.0)
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
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedCrypto = item
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

#Preview{
    HomeView()
}
