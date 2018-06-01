//
//  RestaurantsDataModel.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 5/31/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation
import CoreLocation
import ReactiveKit
import Bond

protocol RestaurantsDataModelContainer {
    
    var restaurantsDataModel: RestaurantsDataModel { get }
    
}

protocol RestaurantsRemoteDataSource {
    
    func queryRestaurants(zipCode: String) -> Signal<[Restaurant], ApiError>
    
}

protocol RestaurantsLocationDataSource {
    
    func requestPlacemark() -> Signal<CLPlacemark, LocationError>
    
}

struct RestaurantsDataModel {
    
    let remoteDataSource: RestaurantsRemoteDataSource
    let locationDataSource: RestaurantsLocationDataSource
    
    func queryRestaurants(zipCode: String) -> Signal<[Restaurant], AppError> {
        return remoteDataSource.queryRestaurants(zipCode: zipCode)
            .mapError(AppError.api)
    }
    
    func queryNearestRestaurants() -> Signal<[Restaurant], AppError> {
        return locationDataSource.requestPlacemark()
            .mapError(AppError.location)
            .flatMapLatest { placemark -> Signal<[Restaurant], AppError> in
                guard let zipCode = placemark.postalCode else {
                    return Signal.failed(.location(error: .postalCodeNotFound))
                }
                
                return self.remoteDataSource.queryRestaurants(zipCode: zipCode)
                    .mapError(AppError.api)
        }
    }
    
}
