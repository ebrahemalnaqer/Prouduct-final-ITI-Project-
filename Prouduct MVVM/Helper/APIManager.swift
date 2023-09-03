//
//  APIManager.swift
//  Prouduct MVVM
//
//  Created by Ebraheem Alnaqer on 02/09/2023.
//

import UIKit

enum DataError : Error{
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
}

typealias Handler = (Result<[Product], DataError>) -> Void

//MARK: - Singleton Design Pattern
final class APIManager {
    
    static let share = APIManager()
    private init(){}
    
    func fetchProducts(complation : @escaping Handler){
        
        guard let url = URL(string: Constant.API.productURL) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data,error == nil else {
                complation(.failure(.invalidData))
                return
                
            }
            guard let response = response as? HTTPURLResponse, 200 ... 299 ~= response.statusCode else {
                    complation(.failure(.invalidResponse))
                return
                
            }
            
            do{
                let productResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
                complation(.success(productResponse.products))
            }catch{
                complation(.failure(.network(error)))
            }
            
        }.resume()
    }
}
