//
//  LocationError.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 6/1/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation

enum LocationError: Error {
    
    case denied
    case restricted
    case postalCodeNotFound
    case geocode(error: Error)
    case manager(error: Error)
    
    static let domain = "LocationErrorDomain"
    
}
