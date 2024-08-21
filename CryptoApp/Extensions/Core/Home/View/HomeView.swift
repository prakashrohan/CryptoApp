//
//  HomeView.swift
//  CryptoApp
//
//  Created by Rohan Prakash on 21/08/24.
//

import SwiftUI

struct HomeView: View {
     
    @State private var showprotfolio : Bool = false
    
    var body: some View {
        ZStack{
            Color.theme.background
                .ignoresSafeArea()
            
            VStack{
                
                homeheader
               
                Spacer(minLength: 0)
               
            }
        }
    }
}

#Preview {
    HomeView()
}

extension HomeView{
    
    private var homeheader : some View{
        
        HStack{
            CircleButton(iconName: showprotfolio ? "plus" : "info")
               // .animation(.none)
            Spacer()
            Text(showprotfolio ? "Protfolio" : "Live Prices" )
                .animation(.none)
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accent)
            
            Spacer()
            CircleButton(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showprotfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()){
                        showprotfolio.toggle()
                    }
                  
                }
        }
        .padding(.horizontal)
        
    }
    
}
