//
//  CoinImageService.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 17/11/25.
//

import Foundation
import SwiftUI

protocol CoinImageServiceProtocol {
    func getCoinImage(
        coinModel: CoinModel,
        imageName: String,
        folderName: String
    ) async throws -> UIImage?
}

final class CoinImageService: CoinImageServiceProtocol {
    
//    @Published var image: UIImage?
    private let fileManager = LocalFileManager.instance
    
    func getCoinImage(
        coinModel: CoinModel,
        imageName: String,
        folderName: String = "coin_images"
    ) async throws -> UIImage? {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            return savedImage
        } else {
            return try await downloadingCoinImage(coinModel: coinModel)
        }
    }
    
    private func downloadingCoinImage(coinModel: CoinModel) async throws -> UIImage? {
        guard let url = URL(string: coinModel.image) else { throw URLError(.badURL) }
        
        let image = try await NetworkingManager.download(url: url)
        return UIImage(data: image)
    }
}
