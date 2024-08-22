import SwiftUI

struct HomeView: View {
    
    @State private var marketData: [MarketData]?
    @State private var globalMarketData: GlobalMarketData?  // This is the instance variable for global market data
    @State private var showPortfolio: Bool = false
    @State private var searchText: String = ""

    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()

            VStack {
                homeHeader
                
                searchBar
                
                // Display market info if available
                if let globalData = globalMarketData {
                    marketInfo(globalData: globalData)
                }
                
               
                
                cryptolist
                
                Spacer(minLength: 0)
            }
            .onAppear {
                fetchGlobalMarketData { data in
                    DispatchQueue.main.async {
                        self.globalMarketData = data
                    }
                }
            }
        }
    }
}

extension HomeView {
    
    private var homeHeader: some View {
        HStack {
            CircleButton(iconName: showPortfolio ? "info" : "plus")
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
    
    private var searchBar: some View {
        TextField("Search...", text: $searchText)
            .font(.subheadline)
            .foregroundColor(Color.theme.accent)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
    }
    
    private func marketInfo(globalData: GlobalMarketData) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Market Info")
                .font(.headline)
                .foregroundColor(.red)

            HStack {
                Text("Market Cap:")
                    .font(.subheadline)
                    .foregroundColor(Color.theme.accent)
                Text("\(globalData.data.marketCapUSD, specifier: "%.0f") USD")
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            HStack {
                Text("24h Trading Volume:")
                    .font(.subheadline)
                    .foregroundColor(Color.theme.accent)
                Text("\(globalData.data.totalVolumeUSD, specifier: "%.0f") USD")
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }

    


    private var cryptolist: some View {
        ZStack {
            VStack {
                if let data = marketData {
                    List(filteredCryptos) { item in
                        HStack {
                            AsyncImage(url: URL(string: item.image)) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                            } placeholder: {
                                ProgressView()
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
        if let data = marketData {
            return data.filter { item in
                searchText.isEmpty ||
                item.name.localizedCaseInsensitiveContains(searchText) ||
                item.symbol.localizedCaseInsensitiveContains(searchText)
            }
        } else {
            return []
        }
    }
}




#Preview{
    HomeView()
}
