//
//  ApiConfig.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 5/30/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation

struct ApiConfig {
    
    static let queueName = "ApiQueue"
    static let endPoint = "https://public.je-apis.com/"
    static let authorizationHeader = "Authorization"
    static let authorization = "Basic VGVjaFRlc3Q6bkQ2NGxXVnZreDVw"
    static let baseHeaders = [
        "Accept-Tenant": "uk",
        "Accept-Language": "en-GB",
        "Host": "public.je-apis.com"
    ]

}
