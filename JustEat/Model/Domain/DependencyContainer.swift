//
//  DependencyContainer.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 5/30/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation

struct DependencyContainer: RestaurantsDataModelContainer {
    
    let restaurantsDataModel: RestaurantsDataModel
    
}


extension DependencyContainer {
    
    static func defaultContainer() -> DependencyContainer {
        let apiService = ApiService()
        let locationService = LocationService()
        
        return DependencyContainer(
            restaurantsDataModel: RestaurantsDataModel(remoteDataSource: apiService, locationDataSource: locationService)
        )
    }
    
}
