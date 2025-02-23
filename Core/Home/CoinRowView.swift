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
    
    var body: some View {
        HStack(spacing: .zero) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(.secondaryText)
                .frame(minWidth: 30)
            Circle()
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, .scale8)
                .foregroundStyle(.accent)
        }
    }
}

#Preview {
    CoinRowView(coin: dev.coin)
}
