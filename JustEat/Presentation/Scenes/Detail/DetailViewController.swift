//
//  DetailViewController.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 6/1/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet weak var infoView: RestaurantInfoView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    weak var flowCoordinator: FlowCoordinator?

    var viewModel: DetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = viewModel.restaurant.name
        infoView.setup(with: viewModel.restaurant)
        addressLabel.text = viewModel.address()
        mapView.region = viewModel.mapRegion()
        mapView.addAnnotation(viewModel.mapAnnotation())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
