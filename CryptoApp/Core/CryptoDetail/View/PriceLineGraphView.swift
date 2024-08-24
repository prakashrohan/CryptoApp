import SwiftUI

struct PriceLineGraphView: View {
    let prices: [Double]
    @State private var animationProgress: CGFloat = 0.0
    @State private var showLabels: Bool = false

    var body: some View {
        GeometryReader { geometry in
            let graphWidth = geometry.size.width - 60
            let graphHeight = geometry.size.height

            ZStack {
                
                Path { path in
                    guard prices.count > 1 else { return }
                    
                    let stepX = graphWidth / CGFloat(prices.count - 1)
                    let maxY = prices.max() ?? 0
                    let minY = prices.min() ?? 0
                    let rangeY = maxY - minY
                    
                    for i in prices.indices {
                        let x = stepX * CGFloat(i)
                        let y = graphHeight * CGFloat(1 - (prices[i] - minY) / rangeY)
                        
                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .trim(from: 0, to: animationProgress)
                .stroke(Color.blue, lineWidth: 2)
                .animation(.linear(duration: 2), value: animationProgress)

               
                Path { path in
                    guard prices.count > 1 else { return }
                    
                    let stepX = graphWidth / CGFloat(prices.count - 1)
                    let maxY = prices.max() ?? 0
                    let minY = prices.min() ?? 0
                    let rangeY = maxY - minY
                    
                    path.move(to: CGPoint(x: 0, y: graphHeight))
                    
                    for i in prices.indices {
                        let x = stepX * CGFloat(i)
                        let y = graphHeight * CGFloat(1 - (prices[i] - minY) / rangeY)
                        
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    
                    path.addLine(to: CGPoint(x: graphWidth, y: graphHeight))
                    path.closeSubpath()
                }
                .fill(Color.blue.opacity(0.2))
                .opacity(Double(animationProgress))
                .animation(.linear(duration: 2), value: animationProgress)

                
                Path { path in
                    path.move(to: CGPoint(x: 0, y: graphHeight))
                    path.addLine(to: CGPoint(x: graphWidth, y: graphHeight))
                }
                .stroke(Color.gray, lineWidth: 1)
                
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: graphHeight))
                }
                .stroke(Color.gray, lineWidth: 1)
                
                
                VStack(alignment: .trailing) {
                    let maxY = prices.max() ?? 0
                    let minY = prices.min() ?? 0
                    let rangeY = maxY - minY
                    let numberOfLabels = 5
                    let stepY = graphHeight / CGFloat(numberOfLabels - 1)
                    
                    ForEach(0..<numberOfLabels, id: \.self) { i in
                        let fraction = CGFloat(i) / CGFloat(numberOfLabels - 1)
                        let yPosition = stepY * CGFloat(numberOfLabels - 1 - i)
                        let price = minY + Double(fraction) * rangeY
                        
                        Text("\(formatNumber(price))")
                            .font(.caption)
                            .fontWeight(.heavy)
                            .foregroundColor(.theme.accent)
                            .frame(width: 60, alignment: .trailing)
                            .padding(.trailing, 8)
                            .opacity(showLabels ? 1.0 : 0.0)
                            .offset(x: 0, y: yPosition - graphHeight / 2)
                            .animation(.easeIn(duration: 0.5).delay(Double(i) * 0.1), value: showLabels) //
                    }
                }
                .frame(width: 60, alignment: .leading)
                .offset(x: 160)
                
            }
            .onAppear {
                animationProgress = 1.0
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showLabels = true
                    }
                }
            }
        }
        .frame(height: 200)
    }
    

}

#Preview {
    PriceLineGraphView(prices: [34000, 35000, 36000, 35500, 34000, 33000, 34000, 35000, 36000, 36500])
        .frame(height: 200)
}
