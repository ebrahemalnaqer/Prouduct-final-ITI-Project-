//
//  FavoritesManager.swift
//  itiGradProject
//
//  Created by Ebraheem Alnaqer on 31/08/2023.
//

import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    
    private var favorites: [Product] = []
    
    
    func addFavorite(_ product: Product) {
        
        // Add the product to your favorites array (if not already there)
                if !favorites.contains(product) {
                    favorites.append(product)
                }
    }
    
    func removeFavorite(_ product: Product) {
        // Remove the product from your favorites array (if present)
                if let index = favorites.firstIndex(of: product) {
                    favorites.remove(at: index)
                }
    }
    
    func getFavorites() -> [Product] {
        return favorites
    }
    
    func isFavorite(_ product: Product) -> Bool {
        return favorites.contains(product)
    }
}
