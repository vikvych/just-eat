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
    
    func queryZipCode() -> Signal<String, AppError> {
        return locationDataSource.requestPlacemark()
            .tryMap({ placemark -> Result<String, LocationError> in
                if let zipCode = placemark.postalCode {
                    return .success(zipCode)
                } else {
                    return .failure(.postalCodeNotFound)
                }
            })
            .mapError(AppError.location)
    }
    
}
