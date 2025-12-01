//
//  PortifolioView.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 25/11/25.
//

import SwiftUI

struct PortifolioView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckMark: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    SearchBarView(searchText: $viewModel.searchText)
                    coinLogoList
                     
                    if selectedCoin != nil {
                        portifolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portifolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundStyle(.secondaryText)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Image(systemName: "checkmark")
                            .opacity(showCheckMark ? 1 : 0)
                        
                        Button {
                            saveButtonPressed()
                        } label: {
                            Text("Save".uppercased())
                                .foregroundStyle(.secondaryText)
                        }
                        .opacity(selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ? 1 : 0)
                    }
                    .font(.headline)
                }
            }
            .onChange(of: viewModel.searchText) { newValue in
                if newValue == "" {
                    removeSelectedCoin()
                }
            }
        }
    }
}

struct PortifolioViewPreview: PreviewProvider {
    static var previews: some View {
        PortifolioView()
            .environmentObject(dev.homeViewModel)
    }
}

extension PortifolioView {
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            LazyHStack(spacing: 10) {
                ForEach(viewModel.searchText.isEmpty ? viewModel.portifolioCoins : viewModel.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                selectedCoin = coin
                            }
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10 )
                                .stroke( selectedCoin?.id == coin.id ? .greenColorToken : .clear, lineWidth: 1)
                        }
                }
            }
            .frame(height: 120)
            .padding(.leading)
        }
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        if let portifolioCoin = viewModel.portifolioCoins.first(where: { $0.id == coin.id }), let amount = portifolioCoin.currentHoldings {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
        
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private var portifolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.toDollarString() ?? String())
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().toDollarString())
            }
        }
        .padding()
        .font(.headline)
    }
    
    private func saveButtonPressed() {
        guard let coin = selectedCoin,
        let amount = Double(quantityText) else { return }
        
        viewModel.updatePortifolio(coin: coin, amount: amount)
        
        withAnimation(.easeIn) {
            showCheckMark = true
            removeSelectedCoin()
        }
        
        UIApplication.shared.endEditing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut) {
                showCheckMark = false
            }
        }
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        viewModel.searchText = ""
    }
}
