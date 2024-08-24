import SwiftUI

struct PriceLineGraphView: View {
    let prices: [Double]
    @State private var animationProgress: CGFloat = 0.0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Draw the price line graph with animation
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
                .trim(from: 0, to: animationProgress) // Apply trim for animation
                .stroke(Color.blue, lineWidth: 2)
                .animation(.linear(duration: 2), value: animationProgress) // Adjust duration as needed

                // Draw shadow below the line graph
                Path { path in
                    guard prices.count > 1 else { return }
                    
                    let stepX = geometry.size.width / CGFloat(prices.count - 1)
                    let maxY = prices.max() ?? 0
                    let minY = prices.min() ?? 0
                    let rangeY = maxY - minY
                    
                    path.move(to: CGPoint(x: 0, y: geometry.size.height))
                    
                    for i in prices.indices {
                        let x = stepX * CGFloat(i)
                        let y = geometry.size.height * CGFloat(1 - (prices[i] - minY) / rangeY)
                        
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                    path.closeSubpath()
                }
                .fill(Color.blue.opacity(0.2)) // Blue shadow with transparency
                .opacity(Double(animationProgress)) // Animate opacity with the graph
                .animation(.linear(duration: 2), value: animationProgress) // Same duration as the graph animation

                // Draw X and Y axes
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geometry.size.height))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                }
                .stroke(Color.gray, lineWidth: 1)
                
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: geometry.size.height))
                }
                .stroke(Color.gray, lineWidth: 1)
                
                // Add labels (e.g., X and Y axis labels)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("Time")
                            .font(.caption)
                            .padding(.bottom, 4)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
                
                VStack {
                    HStack {
                        Text("Price")
                            .font(.caption)
                            .padding(.leading, 4)
                        Spacer()
                    }
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
            }
            .onAppear {
                // Start animation
                animationProgress = 1.0
            }
        }
    }
}

#Preview {
    PriceLineGraphView(prices: [34000, 35000, 36000, 35500, 34000, 33000, 34000, 35000, 36000, 36500])
        .frame(height: 200)
}
