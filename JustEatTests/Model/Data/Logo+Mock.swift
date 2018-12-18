//
//  Logo+Mock.swift
//  JustEatTests
//
//  Created by Ivan Tkachenko on 6/1/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation
@testable import JustEat

extension Logo {
    
    static func mock(url: URL? = URL(string: "https://cdn4.iconfinder.com/data/icons/iconsimple-logotypes/512/github-512.png")) -> Logo {
        return Logo(url: url)
    }
    
}

