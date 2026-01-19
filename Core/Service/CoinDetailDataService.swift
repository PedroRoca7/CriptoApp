//
//  CoinDetailDataService.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 28/11/25.
//

import Foundation

protocol CoinDetailDataServiceProtocol {
    func getCoinsDetails(coin: CoinModel) async throws
}

final class CoinDetailDataService: CoinDetailDataServiceProtocol {
    
    @Published var coinDetail: CoinDetailModel?
    
    func getCoinsDetails(coin: CoinModel) async throws {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { throw URLError(.badURL)
        }
        coinDetail = try await NetworkingManager.download(url: url, type: CoinDetailModel.self)
    }
}
