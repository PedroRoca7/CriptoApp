//
//  CoinRowView.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 16/02/25.
//

import CoreUI
import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: .zero) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, .scale8)
                .foregroundStyle(.accent)
            Spacer()
            
            if showHoldingsColumn {
                VStack {
                    Text(coin.currentHoldingsValue.toDollarString())
                        .bold()
                        .foregroundStyle(.accent)
                    Text((coin.currentHoldings ?? 0).string())
                        .bold()
                        .foregroundStyle(.secondaryText)
                }
            }
            
            VStack(alignment: .trailing) {
                Text(coin.currentPrice.toDollarString())
                    .bold()
                    .foregroundStyle(.accent)
                Text("\(coin.priceChangePercentage24H.string())%")
                    .foregroundStyle(
                        coin.priceChangePercentage24H ?? 0 >= 0 ? .greenColorToken : .redColorToken
                    )
            }
            .padding()
        }
        .background(
            Color.background.opacity(0.001)
        )
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: dev.coin, showHoldingsColumn: false)
    }
}
