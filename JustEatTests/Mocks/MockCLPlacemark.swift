//
//  MockCLPlacemark.swift
//  JustEatTests
//
//  Created by Ivan Tkachenko on 6/3/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation
import CoreLocation

class MockCLPlacemark: CLPlacemark {
    
    private var mockPostalCode: String?
    
    override var postalCode: String? {
        return mockPostalCode
    }
    
    init(postalCode: String) {
        mockPostalCode = postalCode
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
