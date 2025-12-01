//
//  StatisticView.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 24/11/25.
//

import SwiftUI

struct StatisticView: View {
    
    let stat: StatisticModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundStyle(.accent)
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: stat.percentageChange ?? 0 >= 0 ? 0 : 180)
                    )
                
                Text(stat.percentageChange?.toPercentageString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle(stat.percentageChange ?? 0 >= 0 ? .greenColorToken : .redColorToken)
            .opacity(stat.percentageChange == nil ? 0 : 1)
        }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView(stat: dev.state1)
    }
}
