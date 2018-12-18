//
//  ApiError+UserRepresentable.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 6/1/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation

extension ApiError: UserRepresentable {
    
    var userMessage: String {
        switch self {
        case .invalidParams:
            return String(format: Strings.Error.apiNetworkErrorFormat, Strings.Error.apiInvalidParams)
        case .emptyResponse:
            return Strings.Error.apiEmptyResponse
        case .networkError(let error):
            return String(format: Strings.Error.apiNetworkErrorFormat, error.localizedDescription)
        case .failedToParse(let error):
            return String(format: Strings.Error.apiFailedToParse, error.localizedDescription)
        }
    }
    
}
