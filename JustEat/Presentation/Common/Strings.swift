//
//  Strings.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 5/31/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation

struct Strings {
    
    struct Action {
        
        static let search = "Search"
        static let cancel = "Cancel"
        static let settings = "Settings"

    }
    
    struct Error {
        
        static let locationDenied = "Location Services Disabled"
        static let locationDeniedDescription = "Please, enable location services in Settings to be able to search nearest restaurants"
        static let locationNoPlacemark = "No placemark found"
    }

    struct Restaurants {
        
        static let zipCode = "Zip Code"
        static let searchZipCode = "Search a Zip Code"
        static let zipCodeSearchHint = "Search..."
        static let nothingFound = "Nothing found\nYou can use zip code or current location to find restaurants"

    }
    
}
