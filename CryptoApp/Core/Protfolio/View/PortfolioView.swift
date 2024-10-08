import SwiftUI

struct PortfolioView: View {
    
    @Binding var portfolio: [MarketData]
    @State private var showPortfolio: Bool = true
    @State private var showRemoveCryptoOptions: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                portfolioHeader
                    .padding(.top)
                if portfolio.isEmpty {
               
                    Text("No Cryptocurrencies in Portfolio")
                        .font(.headline)
                        .foregroundColor(Color.gray)
                        .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(portfolio) { item in
                            NavigationLink(destination: CryptoDetailView(crypto: item)) {
                                HStack {
                                    if showRemoveCryptoOptions {
                                        Image(systemName: "minus.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(Color.red)
                                            .onTapGesture {
                                                withAnimation(.easeInOut(duration: 0.3)) {
                                                    removeItem(item)
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
                                        .fontWeight(.bold)
                                        .padding(.leading, 8)
                                    
                                    Spacer()
                                    
                                    Text("\(item.current_price, specifier: "%.2f") USD")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(item.price_change_percentage_24h >= 0 ? .green : .red)
                                }
                            }
                        }
                        .onDelete(perform: removeItems)
                    }
                    .listStyle(PlainListStyle()) 
                }
            }
            .padding(.horizontal)
            .navigationBarHidden(true)
        }
    }
    
    private var portfolioHeader: some View {
        HStack {
            CircleButton(iconName: showRemoveCryptoOptions ? "line.3.horizontal" : "minus")
                .onTapGesture {
                    withAnimation(.spring()) {
                        showRemoveCryptoOptions.toggle()
                    }
                }
            Spacer()
            Text("Portfolio")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
            Spacer()
            CircleButton(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: 180))
                .onTapGesture {
                    withAnimation(.spring()) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private func removeItem(_ item: MarketData) {
        if let index = portfolio.firstIndex(where: { $0.id == item.id }) {
            portfolio.remove(at: index)
        }
    }
    
    private func removeItems(at offsets: IndexSet) {
        portfolio.remove(atOffsets: offsets)
    }
}

#Preview {
    PortfolioView(portfolio: .constant([]))
}
