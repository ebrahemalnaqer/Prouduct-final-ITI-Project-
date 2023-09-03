//
//  FavoriteProduct+CoreDataProperties.swift
//  Prouduct MVVM
//
//  Created by Ebraheem Alnaqer on 03/09/2023.
//
//

import Foundation
import CoreData


extension FavoriteProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteProduct> {
        return NSFetchRequest<FavoriteProduct>(entityName: "FavoriteProduct")
    }

    @NSManaged public var id: Double
    @NSManaged public var isFavorited: Bool
    @NSManaged public var price: Double
    @NSManaged public var title: String?
    @NSManaged public var descriptionn: String?
    @NSManaged public var discountPercentage: Double
    @NSManaged public var rating: Double
    @NSManaged public var stock: Double
    @NSManaged public var brand: String?
    @NSManaged public var category: String?
    @NSManaged public var thumbnail: String?
    @NSManaged public var images: String?

}

extension FavoriteProduct : Identifiable {

}
