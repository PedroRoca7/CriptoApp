//
//  CoinDetailViewModel.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 28/11/25.
//

import Combine
import Foundation

class CoinDetailViewModel: ObservableObject {
    
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionaltatistics: [StatisticModel] = []
    @Published var coin: CoinModel
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetail
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] returnCoinDetails in
                self?.overviewStatistics = returnCoinDetails.overview
                self?.additionaltatistics = returnCoinDetails.additional
            }
            .store(in: &cancellables)
        
        coinDetailService.$coinDetail
            .sink { [weak self] returnCoinsDetails in
                self?.coinDescription = returnCoinsDetails?.readableDescription
                self?.websiteURL = returnCoinsDetails?.links?.homepage?.first
                self?.redditURL = returnCoinsDetails?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
    
    private func mapDataToStatistics(
        coinDetailModel: CoinDetailModel?,
        coinModel: CoinModel
    ) -> (
        overview: [StatisticModel],
        additional: [StatisticModel]
    ) {
        return (
            createOverviewArray(coinModel: coinModel),
            createAdditionalArray(
                coinDetailModel: coinDetailModel,
                coinModel: coinModel
            )
        )
    }
    
    private func createOverviewArray(coinModel: CoinModel) -> [StatisticModel] {
        let price = coinModel.currentPrice.toDollarString()
        let priceChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(
            title: "Current Price",
            value: price,
            percentageChange: priceChange
        )
        
        let marketCap = coinModel.marketCap?.abbreviated() ?? String()
        let marketCapChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(
            title: "Market Cap",
            value: marketCap,
            percentageChange: marketCapChange
        )
        
        let rank = String(coinModel.rank)
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = coinModel.totalVolume?.abbreviated() ?? String()
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray: [StatisticModel] = [
            priceStat,
            marketCapStat,
            rankStat,
            volumeStat
        ]
        return overviewArray
    }
    
    private func createAdditionalArray(
        coinDetailModel: CoinDetailModel?,
        coinModel: CoinModel
    ) -> [StatisticModel] {
        let high = coinModel.high24H?.toDollarString() ?? "N/A"
        let highStat = StatisticModel(title: "24H High", value: high)
        
        let low = coinModel.low24H?.toDollarString() ?? "N/A"
        let lowStat = StatisticModel(title: "24H Low", value: low)
        
        let priceChange2 = coinModel.priceChange24H?.toDollarString() ?? "N/A"
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(
            title: "24H Price Change",
            value: priceChange2,
            percentageChange: pricePercentChange
        )
        
        let marketCapChange2 = coinModel.marketCapChange24H?.abbreviated() ?? "N/A"
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(
            title: "24H Market Cap Change",
            value: marketCapChange2,
            percentageChange: marketCapPercentChange
        )
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "N/A" : "\(blockTime)"
        let blockTimeStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "N/A"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray: [StatisticModel] = [
            highStat,
            lowStat,
            priceChangeStat,
            marketCapChangeStat,
            blockTimeStat,
            hashingStat
        ]
        return additionalArray
    }
}
