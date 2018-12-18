//
//  RestaurantsDataModel.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 5/31/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation
import ReactiveKit

protocol RestaurantsDataModelContainer {
    
    var restaurantsDataModel: RestaurantsDataModel { get }
    
}

protocol RestaurantsRemoteDataSource {
    
    func queryRestaurants(zipCode: String) -> Signal<[Restaurant], ApiError>
    
}

protocol RestaurantsLocationDataSource {
    
    func requestZipCode() -> Signal<String, LocationError>
    
}

struct RestaurantsDataModel {
    
    private let remoteDataSource: RestaurantsRemoteDataSource
    private let locationDataSource: RestaurantsLocationDataSource
    
    init(remoteDataSource: RestaurantsRemoteDataSource, locationDataSource: RestaurantsLocationDataSource) {
        self.remoteDataSource = remoteDataSource
        self.locationDataSource = locationDataSource
    }
    
    func queryRestaurants(zipCode: String) -> Signal<[Restaurant], AppError> {
        return remoteDataSource.queryRestaurants(zipCode: zipCode)
            .mapError(AppError.api)
    }
    
    func queryZipCode() -> Signal<String, AppError> {
        return locationDataSource.requestZipCode()
            .mapError(AppError.location)
    }
    
}
