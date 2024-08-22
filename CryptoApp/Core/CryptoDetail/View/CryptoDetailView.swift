////
////  CryptoDetailView.swift
////  CryptoApp
////
////  Created by Rohan Prakash on 22/08/24.
////
//
//import SwiftUI
//
//struct CryptoDetailView: View {
//    let crypto: MarketData
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text(crypto.name)
//                .font(.title)
//                .fontWeight(.bold)
//                .padding(.top)
//
//            VStack(alignment: .leading, spacing: 8) {
//                HStack {
//                    Text("Market Cap:")
//                        .font(.headline)
//                    Spacer()
//                    Text("\(crypto.market_cap, specifier: "%.0f") USD")
//                        .font(.subheadline)
//                }
//                HStack {
//                    Text("Fully Diluted Valuation:")
//                        .font(.headline)
//                    Spacer()
//                    Text("\(crypto.fully_diluted_valuation, specifier: "%.0f") USD")
//                        .font(.subheadline)
//                }
//                HStack {
//                    Text("24 Hour Trading Volume:")
//                        .font(.headline)
//                    Spacer()
//                    Text("\(crypto.total_volume, specifier: "%.0f") USD")
//                        .font(.subheadline)
//                }
//                HStack {
//                    Text("Circulating Supply:")
//                        .font(.headline)
//                    Spacer()
//                    Text("\(crypto.circulating_supply, specifier: "%.0f")")
//                        .font(.subheadline)
//                }
//                HStack {
//                    Text("Total Supply:")
//                        .font(.headline)
//                    Spacer()
//                    Text("\(crypto.total_supply, specifier: "%.0f")")
//                        .font(.subheadline)
//                }
//                HStack {
//                    Text("Max Supply:")
//                        .font(.headline)
//                    Spacer()
//                    Text("\(crypto.max_supply, specifier: "%.0f")")
//                        .font(.subheadline)
//                }
//            }
//            .padding()
//            
//            Spacer()
//        }
//        .navigationTitle(crypto.name)
//        .padding()
//    }
//}
//#Preview {
//    CryptoDetailView()
//}
