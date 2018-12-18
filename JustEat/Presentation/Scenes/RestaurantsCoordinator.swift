//
//  RestaurantsCoordinator.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 5/30/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import UIKit

enum SegueId: String {
    case detail
}

class RestaurantsCoordinator: NSObject, UINavigationControllerDelegate, FlowCoordinator {
    
    @IBOutlet weak var navigationController: UINavigationController!
    
    let dependecyContainer = DependencyContainer.defaultContainer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let viewController = navigationController.viewControllers.first as! RestaurantsViewController
        viewController.viewModel = RestaurantsViewModel(with: dependecyContainer)
        viewController.flowCoordinator = self
    }
    
    func prepareScene<Data>(for segue: UIStoryboardSegue, data: Data) {
        guard let identifier = segue.identifier, let segueId = SegueId(rawValue: identifier) else { return }
        
        switch segueId {
        case .detail:
            let destination = segue.destination as! DetailViewController
            destination.viewModel = DetailViewModel(with: dependecyContainer, restaurant: data as! Restaurant)
            destination.flowCoordinator = self
        }
    }
    
}
