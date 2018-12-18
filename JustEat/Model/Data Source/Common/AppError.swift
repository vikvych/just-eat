//
//  AppError.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 6/1/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation

enum AppError: Error {
    
    case api(error: ApiError)
    case location(error: LocationError)
    case generic(error: Error)
    
}
