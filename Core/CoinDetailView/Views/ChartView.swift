//
//  ChartView.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 28/11/25.
//

import SwiftUI

struct ChartView: View {
    
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let enditingDate: Date
    
    @State private var percentage: CGFloat = 0
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? .greenColorToken : .redColorToken
        
        enditingDate = Date(coinGeckoString: coin.lastUpdated ?? String())
        startingDate = enditingDate.addingTimeInterval(-7*24*60*60)
    }
    
    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(chartBackground)
                .overlay(chartYAxis.padding(.horizontal, 4), alignment: .leading)
            
            chartDateLabel
            
        }
        .font(.caption)
        .bold()
        .foregroundStyle(.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
    }
}

struct ChartViewPreview: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}

extension ChartView {
    
    private var chartView: some View {
        ZStack {
            GeometryReader { geometry in
                let chartPath = createPath(geometry: geometry)
                chartPath
                    .trim(from: 0, to: percentage)
                    .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    .padding(.horizontal, 50)
                    .shadow(color: lineColor.opacity(0), radius: 10, x: 0.0, y: 10)
                    .shadow(color: lineColor.opacity(1), radius: 10, x: 0.0, y: 10)
                    .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0.0, y: 10)
                    .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0.0, y: 20)
                    .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0.0, y: 30)
            }
        }
    }
    
    private func createPath(geometry: GeometryProxy) -> Path {
        var path = Path()
        for index in data.indices {
            let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
            let yAxis = maxY - minY
            let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
            
            if index == 0 {
                path.move(to: CGPoint(x: xPosition, y: yPosition))
            }
            path.addLine(to: CGPoint(x: xPosition, y: yPosition))
        }
        return path
    }
    
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYAxis: some View {
        VStack {
            Text(maxY.abbreviated())
            Spacer()
            Text(((maxY - minY) / 2).abbreviated())
            Spacer()
            Text(minY.abbreviated())
        }
    }
    
    private var chartDateLabel: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(enditingDate.asShortDateString())
        }
    }
}
