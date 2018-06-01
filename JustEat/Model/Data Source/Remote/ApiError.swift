//
//  ApiError.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 5/31/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation

enum ApiError: Error {
    
    case invalidParams
    case emptyResponse
    case networkError(error: Error)
    case failedToParse(error: Error)
    
}
