//
//  CoinDetailDataService.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 28/11/25.
//

import Combine
import Foundation

class CoinDetailDataService {
    
    @Published var coinDetail: CoinDetailModel? = nil
    
    var coinDetailSubscription: AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinsDetails()
     }
    
    func getCoinsDetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        
        coinDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] coins in
                print(coins)
                self?.coinDetail = coins
                self?.coinDetailSubscription?.cancel()
            })
    }
}
