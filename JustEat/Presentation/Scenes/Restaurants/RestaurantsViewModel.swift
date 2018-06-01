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
    let items = Property<[Restaurant]>([])
    
    init(with dependecyContainer: RestaurantsDataModelContainer) {
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
            .flatMapLatest { _ in
                dataModel.queryZipCode()
                    .toLoadingSignal()
                    .liftValue { zipCodeSignal in
                        zipCodeSignal
                            .feedNext(into: self.zipCode, map: { $0 as String? })
                            .flatMapLatest { zipCode in
                                dataModel.queryRestaurants(zipCode: zipCode)
                        }
                    }
        }
        
        return merge(query, queryNearest)
            .feedNext(into: items, map: { state in
                if case .loaded(let items) = state {
                    return items
                } else {
                    return []
                }
            })
    }
    
    func zipCodeTitle() -> SafeSignal<String> {
        return zipCode.map { zipCode in
            if let zipCode = zipCode, !zipCode.isEmpty {
                return zipCode.uppercased()
            } else {
                return Strings.Restaurants.zipCode
            }
        }
    }
    
}
