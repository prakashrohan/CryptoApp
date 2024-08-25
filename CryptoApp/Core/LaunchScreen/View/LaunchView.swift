//
//  LaunchView.swift
//  CryptoApp
//
//  Created by Rohan Prakash on 25/08/24.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var loadingText: [String] = "Fetching Latest Data...".map { String($0) }
    @State private var showLoadingText: Bool = false
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @Binding var showLaunchView: Bool
    
    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image("logo-transparent")
                    .resizable()
                    .frame(width: 100, height: 100)
                
                
                ZStack {
                    if showLoadingText {
                        HStack(spacing: 0) {
                            ForEach(loadingText.indices) { index in
                                Text(loadingText[index])
                                    .font(.headline)
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color.theme.accent)
                                    .offset(y: counter == index ? -5 : 0)
                            }
                        }
                        .transition(AnyTransition.scale.animation(.easeIn))
                    }
                }
                .offset(y: 30)
            }
        }
        .onAppear {
            showLoadingText.toggle()
        }
        .onReceive(timer, perform: { _ in
            withAnimation(.spring()) {
                
                let lastIndex = loadingText.count - 1
                if counter == lastIndex {
                    counter = 0
                    loops += 1
                    if loops >= 2 {
                        showLaunchView = false
                    }
                } else {
                    counter += 1
                }
            }
        })
    }
}

extension Color {
    static let launch = LaunchColor()
}

struct LaunchColor {
    let background = Color("LaunchBackground") // Add this color to your assets
    let accent = Color("LaunchAccent")         // Add this color to your assets
    
    
}



struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}
