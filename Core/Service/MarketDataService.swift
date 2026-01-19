//
//  MarketDataService.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 24/11/25.
//

import Foundation

protocol MarketDataServiceProtocol {
    func getCoins() async throws
}

final class MarketDataService: MarketDataServiceProtocol {
        
    @Published var marketData: MarketDataModel?
    
    func getCoins() async throws {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { throw URLError(.badURL) }
        
        let globalData = try await NetworkingManager.download(url: url, type: GlobalData.self)
        marketData = globalData.data
    }
}
