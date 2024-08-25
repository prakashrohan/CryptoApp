//
//  BitcoinLoad.swift
//  CryptoApp
//
//  Created by Rohan Prakash on 25/08/24.
//

import SwiftUI
import Lottie

struct BitcoinLoad: View {
    var body: some View {
        LottieView(animation: .named("BitcoinLoad.json"))
            .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
            .frame(width: 150 )
        
    }
}

#Preview {
    BitcoinLoad()
}
