//
//  RestaurantsCoordinator.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 5/30/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import UIKit

class RestaurantsCoordinator: NSObject, UITableViewDelegate, FlowCoordinator {
    
    @IBOutlet weak var navigationController: UINavigationController!
    
    let dependecyContainer = DependencyContainer.defaultContainer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let viewController = navigationController.viewControllers.first as! RestaurantsViewController
        viewController.viewModel = RestaurantsViewModel(dependecyContainer: dependecyContainer)
    }
    
    func prepareScene(for segue: UIStoryboardSegue) {
        
    }
    
}
