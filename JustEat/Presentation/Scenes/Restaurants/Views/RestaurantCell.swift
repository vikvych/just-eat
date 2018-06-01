//
//  RestaurantCell.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 5/31/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
}
