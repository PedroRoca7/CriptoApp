//
//  CoinDetailView.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 28/11/25.
//

import SwiftUI

struct CoinDetailViewLoading: View {
    
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                CoinDetailView(coin: coin)
            }
        }
    }
}

struct CoinDetailView: View {
    
    @StateObject var viewModel: CoinDetailViewModel
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @State private var showDescription: Bool = false
    private let spacing: CGFloat = 20
    
    init(coin: CoinModel) {
        _viewModel = StateObject(
            wrappedValue: CoinDetailViewModel(coin: coin)
        )
    }
    
    var body: some View {
        ScrollView {
            
            VStack {
                ChartView(coin: viewModel.coin)
                    .padding()
                VStack(spacing: 20) {
                    overviewTitle
                    Divider()
                    
                    ZStack {
                        if let coinDescription = viewModel.coinDescription, !coinDescription.isEmpty {
                            VStack(alignment: .leading) {
                                Text(coinDescription)
                                    .lineLimit(showDescription ? nil : 3)
                                    .font(.callout)
                                    .foregroundStyle(.secondaryText)
                                Button {
                                    withAnimation(.easeInOut) {
                                        showDescription.toggle()
                                    }
                                } label: {
                                    Text(showDescription ? "Less" : "Read more...")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .padding(.vertical, 4)
                                }
                                .accentColor(.blue)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    overviewGrid
                    additionalTitle
                    Divider()
                    additionalGrid
                    
                    ZStack {
                        VStack(alignment: .leading, spacing: 20) {
                            if let websiteURL = viewModel.websiteURL, let url = URL(string: websiteURL) {
                                Link("Website", destination: url)
                            }
                            
                            if let redditString = viewModel.redditURL, let url = URL(string: redditString) {
                                Link("Reddit", destination: url)
                            }
                        }
                    }
                    .accentColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                    
                }
                .padding()
            }
        }
        .navigationTitle(viewModel.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTrailingItems
            }
        }
    }
}

struct CoinDetailViewPreview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CoinDetailView(coin: dev.coin)
        }
    }
}

extension CoinDetailView {
    
    private var navigationBarTrailingItems: some View {
        HStack {
            Text(viewModel.coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(.secondaryText)
            CoinImageView(coin: viewModel.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundStyle(.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundStyle(.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []
        ) {
            ForEach(viewModel.overviewStatistics) { stats in
                StatisticView(stat: stats)
            }
        }
    }
    
    private var additionalGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []
        ) {
            ForEach(viewModel.additionaltatistics) { stats in
                StatisticView(stat: stats)
            }
        }
    }
    
}

