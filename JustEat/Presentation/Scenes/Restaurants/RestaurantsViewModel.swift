//
//  RestaurantsViewModel.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 5/31/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation
import ReactiveKit

struct RestaurantsViewModel {
    
    let dependecyContainer: RestaurantsDataModelContainer
    let zipCode: Property<String?> = Property(nil)
    
    init(dependecyContainer: RestaurantsDataModelContainer) {
        self.dependecyContainer = dependecyContainer
    }
    
    func restaurants(queryNearestSignal: SafeSignal<Void>) -> LoadingSignal<[Restaurant], AppError> {
        let dataModel = dependecyContainer.restaurantsDataModel
        
        let query = zipCode.toSignal()
            .skip(first: 1)
            .flatMapLatest { zipCode -> LoadingSignal<[Restaurant], AppError> in
                let signal: Signal<[Restaurant], AppError>
                
                if let zipCode = zipCode {
                    signal = dataModel.queryRestaurants(zipCode: zipCode)
                } else {
                    signal = Signal.just([])
                }
                
                return signal.toLoadingSignal()
        }
        
        let queryNearest = queryNearestSignal
            .flatMapLatest {
                dataModel.queryNearestRestaurants()
                    .toLoadingSignal()
        }
        
        return merge(query, queryNearest)
    }
    
}
