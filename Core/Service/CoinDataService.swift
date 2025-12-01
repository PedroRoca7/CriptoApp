//
//  CoinDataService.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 14/11/25.
//

import Combine
import Foundation

class CoinDataService {
    
    @Published var allCoins: [CoinModel] = []
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
     }
    
    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage-24hh") else { return }
        
        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] coins in
                print(coins)
                self?.allCoins = coins
                self?.coinSubscription?.cancel()
            })
    }
}
