//
//  CoreDataHelper.swift
//  Prouduct MVVM
//
//  Created by Ebraheem Alnaqer on 03/09/2023.
//

import CoreData
import UIKit

class CoreDataHelper {
    static let shared = CoreDataHelper()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Prouduct_MVVM") // Replace with your data model name
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveFavoriteProduct(product: Product, isFavorited: Bool) {
        let context = persistentContainer.viewContext
        let favoriteProduct = FavoriteProduct(context: context)
        
        // Map properties from the Product model to the FavoriteProduct entity
        favoriteProduct.id = Double(product.id)
        favoriteProduct.title = product.title
        favoriteProduct.price = Double(product.price)
        favoriteProduct.isFavorited = isFavorited // Set the favorited state
        
        do {
            try context.save()
        } catch {
            print("Failed to save favorite product: \(error)")
        }
    }
    
    func updateFavoriteProduct(productId: Int64, isFavorited: Bool) {
        let context = persistentContainer.viewContext
        if let favoriteProduct = fetchFavoriteProduct(productId: productId) {
            favoriteProduct.isFavorited = isFavorited // Update the favorited state
            
            do {
                try context.save()
            } catch {
                print("Failed to update favorite product: \(error)")
            }
        }
    }
    
    func deleteFavoriteProduct(productId: Int64) {
        let context = persistentContainer.viewContext
        if let favoriteProduct = fetchFavoriteProduct(productId: productId) {
            context.delete(favoriteProduct)
            
            do {
                try context.save()
            } catch {
                print("Failed to delete favorite product: \(error)")
            }
        }
    }
    
    func fetchFavoriteProduct(productId: Int64) -> FavoriteProduct? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %ld", productId)
        
        do {
            let favoriteProducts = try context.fetch(fetchRequest)
            return favoriteProducts.first
        } catch {
            print("Failed to fetch favorite product: \(error)")
            return nil
        }
    }
    
    func fetchAllFavoriteProducts() -> [FavoriteProduct] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch favorite products: \(error)")
            return []
        }
    }
    
    
    func isProductFavorited(productId: Int64) -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %ld", productId)

        do {
            let favoriteProducts = try context.fetch(fetchRequest)
            return !favoriteProducts.isEmpty
        } catch {
            print("Failed to fetch favorite product: \(error)")
            return false
        }
    }

}
