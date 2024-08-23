//
//  PriceLineGraphView.swift
//  CryptoApp
//
//  Created by Rohan Prakash on 23/08/24.
//

import SwiftUI

struct PriceLineGraphView: View {
    let prices: [Double]

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                guard prices.count > 1 else { return }
                
                let stepX = geometry.size.width / CGFloat(prices.count - 1)
                let maxY = prices.max() ?? 0
                let minY = prices.min() ?? 0
                let rangeY = maxY - minY
                
                for i in prices.indices {
                    let x = stepX * CGFloat(i)
                    let y = geometry.size.height * CGFloat(1 - (prices[i] - minY) / rangeY)
                    
                    if i == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(Color.blue, lineWidth: 2)
        }
    }
}

#Preview {
    PriceLineGraphView(prices: [34000, 35000, 36000, 35500, 34000, 33000, 34000, 35000, 36000, 36500])
        .frame(height: 200)
}
