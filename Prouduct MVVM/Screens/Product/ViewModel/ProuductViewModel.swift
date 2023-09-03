//
//  ProuductViewModel.swift
//  Prouduct MVVM
//
//  Created by Ebraheem Alnaqer on 02/09/2023.
//

import Foundation

final class ProuductViewModel{
    //MARK: - Var
    var prouduts: [Product] = []
    var eventHandler : ((_ event:Event) -> Void)? //Data Binding Clouser
 
    func fetchProuduct(){
        self.eventHandler?(.loading)
        //to try the API
        APIManager.share.fetchProducts { response in
            self.eventHandler?(.stopLoading)
            switch response {
            case .success(let products):
                self.prouduts = products
                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                print(error)
                self.eventHandler?(.error(error))
            }
        }
    }
}


extension ProuductViewModel{
    enum Event{
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}
