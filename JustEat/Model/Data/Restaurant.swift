//
//  Restaurant.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 5/31/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation

struct Restaurant: Equatable, Decodable {
    
    let id: ID
    let name: String
    let ratingStars: Double
    let logo: [Logo]
    let cuisineTypes: [CousineType]
    let isOpenNow: Bool
    let latitude: Double
    let longitude: Double
    let address: String?
    let city: String?
    let postcode: String?

}
