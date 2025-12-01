//
//  PortifolioDataService.swift
//  CriptoApp
//
//  Created by Pedro Henrique Roca Moreira on 25/11/25.
//

import Foundation
import CoreData

class PortifolioDataService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortifolioContainer"
    private let entityName: String = "PortifolioEntity"
    
    @Published var savedEntities: [PortifolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            self.getPortifolio()
        }
    }
    
    func updatePortifolio(coin: CoinModel, amount: Double) {
        
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    private func getPortifolio() {
        let request = NSFetchRequest<PortifolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
             print("Error fetching portifolio entities: \(error)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortifolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortifolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortifolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving portifolio entity: \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortifolio()
    }
    
}
