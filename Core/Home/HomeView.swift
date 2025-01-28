//
//  HomeView.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 26/01/25.
//

import SwiftUI
import CoreUI

struct HomeView: View {
    
    @State private var showPortifolio = false
    
    var body: some View {
        BaseView(
            title: "Live Prices",
            leftIcon: AnyView(leftIcon),
            rightIcon: AnyView(rightIcon)
        ) {
          
        }
    }
}

#Preview {
    NavigationView {
        HomeView()
            .navigationBarHidden(true)
    }
}

extension HomeView {
    
    //MARK: - Layouts
    
    private var leftIcon: some View {
        CircleButton(iconName: showPortifolio ? "plus" : "info")
            .animation(nil, value: showPortifolio)
            .background(
                CircleButtonAnimation(isAnimating: $showPortifolio)
            )
    }
    
    private var rightIcon: some View {
        CircleButton(iconName: "chevron.right")
            .rotationEffect(Angle(degrees:  showPortifolio ? 180 : 0))
            .onTapGesture {
                withAnimation(.spring()) {
                    showPortifolio.toggle()
                }
            }
    }
}
