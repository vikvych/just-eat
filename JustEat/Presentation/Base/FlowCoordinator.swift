//
//  FlowCoordinator.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 5/30/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import UIKit

protocol FlowCoordinator: AnyObject {
    
    func prepareScene(for segue: UIStoryboardSegue)

}
