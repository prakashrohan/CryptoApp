import SwiftUI

struct PriceLineGraphView: View {
    let prices: [Double]
    @State private var animationProgress: CGFloat = 0.0
    @State private var showLabels: Bool = false

    var body: some View {
        GeometryReader { geometry in
            let graphWidth = geometry.size.width
            let graphHeight = geometry.size.height
            let padding: CGFloat = 16

            ZStack {
                Color.clear
                Path { path in
                    guard prices.count > 1 else { return }
                    
                    let stepX = graphWidth / CGFloat(prices.count - 1)
                    let maxY = prices.max() ?? 0
                    let minY = prices.min() ?? 0
                    let rangeY = maxY - minY
                    
                    for i in prices.indices {
                        let x = stepX * CGFloat(i)
                        let y = graphHeight * CGFloat(1 - (prices[i] - minY) / rangeY) * 0.9
                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .trim(from: 0, to: animationProgress)
                .stroke(Color.blue.gradient, lineWidth: 3)
                .shadow(color: Color.blue.opacity(0.5), radius: 5, x: 0, y: 5)
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
                        let y = graphHeight * CGFloat(1 - (prices[i] - minY) / rangeY) * 0.9
                        
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    
                    path.addLine(to: CGPoint(x: graphWidth, y: graphHeight))
                    path.closeSubpath()
                }
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.clear]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .opacity(Double(animationProgress))
                .animation(.linear(duration: 2), value: animationProgress)

                
                Path { path in
                    path.move(to: CGPoint(x: 0, y: graphHeight))
                    path.addLine(to: CGPoint(x: graphWidth, y: graphHeight))
                }
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)

                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: graphHeight))
                }
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                
       
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
                            .foregroundStyle(Color.theme.accent)
                            .frame(width: 60, alignment: .trailing)
                            .padding(.trailing, 8)
                            .opacity(showLabels ? 1.0 : 0.0)
                            .offset(x: 0, y: yPosition - graphHeight / 2)
                            .animation(.easeIn(duration: 0.5).delay(Double(i) * 0.1), value: showLabels)
                    }
                }
                .frame(width: 60, alignment: .leading)
                .offset(x: -175)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                     
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.bottom, 8)
                    }
                }
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
        .frame(height: 250)
        .padding(.horizontal, 16)
    }
    
}

#Preview {
    PriceLineGraphView(prices: [34000, 35000, 36000, 35500, 34000, 33000, 34000, 35000, 36000, 36500])
        .frame(height: 250)
}

