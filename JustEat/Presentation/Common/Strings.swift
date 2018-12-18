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
        
        static let apiNetworkErrorFormat = "Network request failed cause: %@"
        static let apiInvalidParams = "Invalid params"
        static let apiEmptyResponse = "Server returned empty response"
        static let apiFailedToParse = "Failed to to parse network response: %@"
        
        static let locationDenied = "Location Services access denied"
        static let locationDeniedDescription = "Please, grant access to Location Services in Settings to be able to search nearest restaurants"
        static let locationRestricted = "Location Services access restricted"
        static let locationPostalCodeNotFound = "Postal code not found"
        static let locationGeocodeErrorFormat = "Failed to get location info cause: %@"
        static let locationManagerErrorFormat = "Location Services failed cause: %@"
        
    }

    struct Restaurants {
        
        static let zipCode = "Zip Code"
        static let searchZipCode = "Search a Zip Code"
        static let zipCodeSearchHint = "Search..."
        static let nothingFound = "Nothing found\nYou can use zip code or current location to find restaurants"

    }
    
}
