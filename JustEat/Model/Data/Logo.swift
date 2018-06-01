//
//  Logo.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 6/1/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation

struct Logo: Equatable, Decodable {
    
    let url: URL?
    
    enum CodingKeys: String, CodingKey {
        case url = "standardResolutionURL"
    }
    
}
