//
//  AppError+UserRepresentable.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 6/1/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation

extension AppError: UserRepresentable {
    
    var userMessage: String {
        switch self {
        case .api(let error):
            return error.userMessage
        case .location(let error):
            return error.userMessage
        case .generic(let error):
            return error.localizedDescription
        }
    }
    
}
