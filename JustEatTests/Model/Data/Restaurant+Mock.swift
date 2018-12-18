//
//  Restaurant+Mock.swift
//  JustEatTests
//
//  Created by Ivan Tkachenko on 6/1/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation
@testable import JustEat

extension Restaurant {
    
    static func mock(id: ID = 0,
                     name: String = String(),
                     ratingStars: Double = 0.0,
                     logo: [Logo] = [],
                     cuisineTypes: [CousineType] = [],
                     isOpenNow: Bool = false,
                     latitude: Double = 0.0,
                     longitude: Double = 0.0,
                     address: String? = nil,
                     city: String? = nil,
                     postcode: String? = nil) -> Restaurant {
        return Restaurant(id: id, name: name, ratingStars: ratingStars, logo: logo, cuisineTypes: cuisineTypes, isOpenNow: isOpenNow, latitude: latitude, longitude: longitude, address: address, city: city, postcode: postcode)
    }
    
}
