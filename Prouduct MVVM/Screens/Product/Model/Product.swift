//
//  Product.swift
//  Prouduct MVVM
//
//  Created by Ebraheem Alnaqer on 02/09/2023.
//

import Foundation


struct Product: Decodable,Hashable {
    let id : Int
    let title : String
    let description : String
    let price : Double
    let discountPercentage : Float
    let rating : Float
    let stock : Int
    let brand : String
    let category :String
    let thumbnail : String
    let images: [String]
    
    
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func ==(lhs: Product, rhs: Product) -> Bool {
            return lhs.id == rhs.id
        }
    
}


struct ProductResponse: Decodable {
    let products: [Product]
}
