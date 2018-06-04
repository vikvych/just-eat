//
//  LocationError+UserRepresentable.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 6/1/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation

extension LocationError: UserRepresentable {
    
    var userMessage: String {
        switch self {
        case .denied:
            return Strings.Error.locationDenied
        case .restricted:
            return Strings.Error.locationRestricted
        case .postalCodeNotFound:
            return Strings.Error.locationPostalCodeNotFound
        case .geocode(let error):
            return String(format: Strings.Error.locationGeocodeErrorFormat, error.localizedDescription)
        case .manager(let error):
            return String(format: Strings.Error.locationManagerErrorFormat, error.localizedDescription)
        }
    }
    
}
