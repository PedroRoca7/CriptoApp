//
//  HomeStatsView.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 24/11/25.
//

import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @Binding var showPortfolio: Bool
        
    var body: some View {
        HStack {
            ForEach(viewModel.statistics) { statistic in
                StatisticView(stat: statistic)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(
            width: UIScreen.main.bounds.width,
            alignment: showPortfolio ? .trailing : .leading
        )
    }
}

struct HomeStatsViewPreview: PreviewProvider {
    static var previews: some View {
        HomeStatsView(showPortfolio: .constant(false))
            .environmentObject(dev.homeViewModel)
    }
}
