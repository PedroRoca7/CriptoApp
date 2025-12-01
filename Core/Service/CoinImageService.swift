//
//  CoinImageService.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 17/11/25.
//

import Combine
import Foundation
import SwiftUI

class CoinImageService {
    
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let coinModel: CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName: String = "coin_images"
    private let imageName: String
 
    init(coinModel: CoinModel) {
        self.coinModel = coinModel
        self.imageName = coinModel.id
        getCoinImage() 
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            downloadingCoinImage()
        }
    }
    
    private func downloadingCoinImage() {
        guard let url = URL(string: coinModel.image) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] image in
                    guard let self,
                          let downloadImage = image else { return }
                    self.image = downloadImage
                    self.imageSubscription?.cancel()
                    self.fileManager.saveImage(
                        image: downloadImage,
                        imageName: imageName,
                        folderName: folderName
                    )
            })
    }
    
}
