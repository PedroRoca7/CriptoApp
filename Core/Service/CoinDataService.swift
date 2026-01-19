//
//  CoinDataService.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 14/11/25.
//

import Foundation

protocol CoinDataServiceProtocol {
    func getCoins() async throws
}

final class CoinDataService: CoinDataServiceProtocol {

    @Published var allCoins: [CoinModel] = []
    
    func getCoins() async throws {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage-24hh") else { throw URLError(.badURL) }
        
        let coins = try? await NetworkingManager.download(url: url, type: [CoinModel].self)
        if let coins = coins {
            allCoins = coins
        }
    }
}
