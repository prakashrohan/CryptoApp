//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Rohan Prakash on 20/08/24.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    @State private var showLaunchView: Bool = true
    var body: some Scene {
        WindowGroup {
            if showLaunchView {
                LaunchView(showLaunchView: $showLaunchView)}
            else{
                NavigationView{
                    HomeView()
                        .toolbar(.hidden)
                }
            }

           
        }
    }
}
