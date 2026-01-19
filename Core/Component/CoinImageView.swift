//
//  CoinImageView.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 17/11/25.
//

import Combine
import CoreUI
import SwiftUI

@MainActor
class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading: Bool = false
    
    private let coin: CoinModel
    private let dataService: CoinImageService
    private var cancellables = Set<AnyCancellable>()
 
    init(coin: CoinModel) {
        self.coin = coin
        self.dataService = CoinImageService()
        self.isLoading = true
    }
    
    func loadImage() async {
        isLoading = true
        do {
            image = try await dataService.getCoinImage(
                coinModel: coin,
                imageName: coin.id
            )
        } catch {
            print("Erro ao carregar imagem:", error)
        }
        isLoading = false
    }
    
//    func addSubscribers() async {
//        try? await dataService.getCoinImage(coinModel: coin, imageName: coin.id)
//        dataService.$image
//            .sink { [weak self] _ in
//                self?.isLoading = false
//            } receiveValue: { [weak self] image in
//                self?.image = image
//            }
//            .store(in: &cancellables)
//    }
}

struct CoinImageView: View {
    
    @StateObject var viewModel: CoinImageViewModel
    
    init(coin: CoinModel) {
        _viewModel = StateObject(
            wrappedValue: CoinImageViewModel(coin: coin)
        )
    }
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if viewModel.isLoading {
                Circle()
                    .frame(width: 30, height: 30)
                    .shimmer(
                        isActive: true,
                        animateOpacity: true,
                        animateScale: true
                    )
            } else {
                Image(systemName: "questionmark")
                    .foregroundStyle(.secondaryText)
            }
        }
        .task {
            await viewModel.loadImage()
        }
    }
}

struct CoinImageViewPreview: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: dev.coin)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
