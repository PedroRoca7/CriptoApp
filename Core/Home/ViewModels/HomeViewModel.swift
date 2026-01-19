//
//  HomeViewModel.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 26/01/25.
//

import Combine
import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = []
    
    @Published var allCoins: [CoinModel] = []
    @Published var portifolioCoins: [CoinModel] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .holdings
    @Published var rotationDegrees = 0.0
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortifolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
        addSubscribe()
    }
    
    private func addSubscribe() {
        $searchText
            .receive(on: DispatchQueue.main)
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] returnCoins in
                self?.allCoins = returnCoins
            }
            .store(in: &cancellables)
        
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnedCoins in
                guard let self else { return }
                self.portifolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins) 
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .receive(on: DispatchQueue.main)
            .combineLatest($portifolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func updatePortifolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortifolio(coin: coin, amount: amount)
    }
    
    func reloadData() async throws {
        isLoading = true
        try await coinDataService.getCoins()
        try await marketDataService.getCoins()
        HapitcManager.notification(type: .success)
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        var updateCoins = filterCoins(text: text, coins: coins)
        sortCoin(sort: sort, coins: &updateCoins)
        return updateCoins
    }
    
    private func sortCoin(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holdings:
            coins.sort { $0.rank < $1.rank }
        case .rankReversed, .holdingsReversed:
            coins.sort { $0.rank > $1.rank }
        case .price:
            coins.sort { $0.currentPrice > $1.currentPrice }
        case .priceReversed:
            coins.sort { $0.currentPrice < $1.currentPrice }
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        switch sortOption {
        case .holdings:
            return coins.sorted { $0.currentHoldings ?? 0 > $1.currentHoldings ?? 0 }
        case .holdingsReversed:
            return coins.sorted { $0.currentHoldings ?? 0 < $1.currentHoldings ?? 0 }
        default:
            return coins
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(_ allCoins: [CoinModel], portfolioEntities: [PortifolioEntity]) -> [CoinModel] {
        allCoins
            .compactMap { coin -> CoinModel? in
                guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        return coins.filter { coin -> Bool in
            return coin.name
                .lowercased()
                .contains(lowercasedText) || coin.symbol
                .lowercased()
                .contains(lowercasedText) || coin.id
                .lowercased()
                .contains(lowercasedText)
        }
    }
    
    private func mapGlobalMarketData(
        marketDataModel: MarketDataModel?,
        portifolioCoin: [CoinModel]
    ) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else { return stats }
        let marketCap = StatisticModel(
            title: "Market Cap",
            value: data.marketCap,
            percentageChange: data.marketCapChangePercentage24HUsd
        )
        let volume24h = StatisticModel(
            title: "24h Volume",
            value: data.volume
        )
        let btcDominance = StatisticModel(
            title: "BTC Dominance",
            value: data.btcDominance
        )
        
        let portfolioValue =
            portifolioCoin
                .map { $0.currentHoldingsValue }
                .reduce(0, +)
        
        let portifolio = StatisticModel(
            title: "Portifolio Value",
            value: portfolioValue.toDollarString(),
            percentageChange: nil
        )
        stats.append(contentsOf: [marketCap, volume24h, btcDominance, portifolio])
        return stats
    }
}
