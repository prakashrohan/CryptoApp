//
//  ContentView.swift
//  CryptoApp
//
//  Created by Rohan Prakash on 20/08/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Color.theme.accent.ignoresSafeArea()
            VStack{
                Text("accentcolor")
                    .font(.title)
                    .foregroundStyle(Color.theme.green)
                
                Text("this the the new text")
                    .font(.largeTitle)
                    .foregroundStyle(Color.theme.red)
                    
                
            }
            
        }
    }
}

#Preview {
    ContentView()
}
