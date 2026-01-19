//
//  HomeView.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 26/01/25.
//

import SwiftUI
import CoreUI

struct HomeView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var showPortifolio = false
    @State private var showPortifolioView = false
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    @State private var goToChatView = false
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack {
                
                header
                
                if viewModel.statistics.isEmpty {
                    shimmerHeaderStats
                } else {
                    HomeStatsView(showPortfolio: $showPortifolio)
                }
                
                SearchBarView(searchText: $viewModel.searchText)
                
                columnTiltes
                    .sheet(isPresented: $showPortifolioView) {
                        PortifolioView()
                            .environmentObject(viewModel)
                    }
                
                if !showPortifolio {
                    if viewModel.allCoins.isEmpty {
                        shimmerCoinsList
                    } else {
                        allCoinsList
                            .transition(.move(edge: .leading))
                    }
                } else {
                    if viewModel.allCoins.isEmpty {
                        portifolioCoinsList
                    } else {
                        portifolioCoinsList
                            .transition(.move(edge: .trailing))
                    }
                }
                Spacer(minLength: 0)
            }
        }
        .background(
            Group {
                NavigationLink(
                    destination: CoinDetailViewLoading(coin: $selectedCoin),
                    isActive: $showDetailView
                ) { EmptyView() }
                
                NavigationLink(
                    destination: ChatView()
                        .environmentObject(ChatViewModel(allCoins: viewModel.allCoins)),
                    isActive: $goToChatView
                ) { EmptyView() }
            }
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(dev.homeViewModel)
    }
}

extension HomeView {
    
    //MARK: - Layouts
    
    private var leftIcon: some View {
        CircleButton(
            iconName: showPortifolio ? "plus" : "bubble.left.and.bubble.right.fill",
            iconColor: .accent,
            backgroundColor: .background
        )
        .animation(nil, value: showPortifolio)
        .onTapGesture {
            if showPortifolio {
                showPortifolioView.toggle()
            } else {
                goToChatView = true
            }
        }
        .background(
            CircleButtonAnimation(isAnimating: $showPortifolio)
        )
    }
    
    private var rightIcon: some View {
        CircleButton(
            iconName: "chevron.right",
            iconColor: .accent,
            backgroundColor: .background
        )
        .rotationEffect(Angle(degrees:  showPortifolio ? 180 : 0))
        .onTapGesture {
            withAnimation(.spring()) {
                showPortifolio.toggle()
            }
        }
    }
    
    private var header: some View {
        HStack {
            leftIcon
            Spacer()
            Text(showPortifolio ? "Portifolio" : "Live prices" )
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(.accent)
            Spacer()
            rightIcon
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(viewModel.allCoins) { coin in
                CoinRowView(
                    coin: coin,
                    showHoldingsColumn: false
                )
                .listRowInsets(
                    .init(
                        top: 10,
                        leading: 0,
                        bottom: 10,
                        trailing: 0
                    )
                )
                .onTapGesture {
                    segue(coin: coin)
                }
            }
        }
        .listStyle(.plain)
    }
    
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var shimmerHeaderStats: some View {
        HStack {
            ForEach(0..<3) { _ in
                VStack {
                    Rectangle()
                        .frame(width: 80, height: 20)
                        .shimmer(
                            isActive: true,
                            animateOpacity: true,
                            animateScale: true
                        )
                    Rectangle()
                        .frame(width: 80, height: 20)
                        .shimmer(
                            isActive: true,
                            animateOpacity: true,
                            animateScale: true
                        )
                }
                Spacer()
            }
        }
        .padding()
    }
    
    private var shimmerCoinsList: some View {
        ForEach(0..<6) { _ in
            HStack {
                Circle()
                    .frame(width: 30, height: 30)
                    .shimmer(
                        isActive: true,
                        animateOpacity: true,
                        animateScale: true
                    )
                Rectangle()
                    .frame(width: 80, height: 20)
                    .shimmer(
                        isActive: true,
                        animateOpacity: true,
                        animateScale: true
                    )
                Spacer()
                VStack {
                    Rectangle()
                        .frame(width: 80, height: 20)
                        .shimmer(
                            isActive: true,
                            animateOpacity: true,
                            animateScale: true
                        )
                    Rectangle()
                        .frame(width: 60, height: 20)
                        .shimmer(
                            isActive: true,
                            animateOpacity: true,
                            animateScale: true
                        )
                }
                
            }
            .padding()
        }
    }
    
    private var portifolioCoinsList: some View {
        List {
            ForEach(viewModel.portifolioCoins) { coin in
                CoinRowView(
                    coin: coin,
                    showHoldingsColumn: true
                )
                .listRowInsets(
                    .init(
                        top: 10,
                        leading: 0,
                        bottom: 10,
                        trailing: 0
                    )
                )
                .onTapGesture {
                    segue(coin: coin)
                }
            }
        }
        .listStyle(.plain)
    }
    
    private var columnTiltes: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((viewModel.sortOption == .rank || viewModel.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .rank ? .rankReversed : .rank
                }
            }
            
            
            Spacer()
            if showPortifolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((viewModel.sortOption == .holdings || viewModel.sortOption == .holdingsReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: viewModel.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        viewModel.sortOption = viewModel.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((viewModel.sortOption == .price || viewModel.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .price ? 0 : 180))
            }
            .frame(
                width: UIScreen.main.bounds.width / 3.5,
                alignment: .trailing
            )
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .price ? .priceReversed : .price
                }
            }
            
            Button {
                withAnimation(.linear(duration: 2.0)) {
                    viewModel.rotationDegrees += 360
                    Task {
                        do {
                            try await viewModel.reloadData()
                        } catch {
                            
                        }
                    }
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: viewModel.rotationDegrees))
        }
        .font(.caption)
        .foregroundStyle(.secondaryText)
        .padding(.horizontal)
    }
}
