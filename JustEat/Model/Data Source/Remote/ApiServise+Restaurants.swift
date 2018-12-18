//
//  ApiServise+Restaurants.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 5/31/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation
import ReactiveKit

struct RestaurantsResult: Decodable {
    
    let restaurants: [Restaurant]
    
}

extension ApiService: RestaurantsRemoteDataSource {
    
    func queryRestaurants(zipCode: String) -> Signal<[Restaurant], ApiError> {
        return query(ApiAction.restaurants, parameters: ["q": zipCode])
            .map { (result: RestaurantsResult) in result.restaurants }
    }
    
}
