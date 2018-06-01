//
//  DetailViewModel.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 6/1/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation
import ReactiveKit
import MapKit

private let mapRegionSize: CLLocationDistance = 1000.0

struct DetailViewModel {
    
    let restaurant: Restaurant
    
    private let dependencyContainer: RestaurantsDataModelContainer
    
    init(with dependencyContainer: RestaurantsDataModelContainer, restaurant: Restaurant) {
        self.dependencyContainer = dependencyContainer
        self.restaurant = restaurant
    }
    
    func address() -> String {
        return [
            restaurant.address,
            restaurant.city,
            restaurant.postcode
        ]
            .compactMap { $0 }
            .joined(separator: "\n")
    }
    
    func mapRegion() -> MKCoordinateRegion {
        return MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude), mapRegionSize, mapRegionSize)
    }
    
    func mapAnnotation() -> RestaurantAnnotation {
        return RestaurantAnnotation(title: restaurant.name, coordinate: CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude))
    }
    
}
