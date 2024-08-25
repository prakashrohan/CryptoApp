//
//  NotFound.swift
//  CryptoApp
//
//  Created by Rohan Prakash on 25/08/24.
//

import SwiftUI
import Lottie

struct NotFound: View {
    var body: some View {
        LottieView(animation: .named("NotFoundAnimation.json"))
            .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
            .frame(width: 300 )
    }
}

#Preview {
    NotFound()
}
