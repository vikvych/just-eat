//
//  RestaurantCell.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 5/31/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {

    @IBOutlet weak var infoView: RestaurantInfoView!
    @IBOutlet weak var shadowView: UIView!
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        shadowView.layer.shadowRadius = 2.0
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.masksToBounds = false
        shadowView.layer.cornerRadius = 6.0
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let duration: TimeInterval = animated ? 0.05 : 0.0
        
        UIView.animate(withDuration: duration) {
            self.shadowView.backgroundColor = highlighted ? UIColor(white: 0.9, alpha: 0.1) : .white
            self.infoView.logoView.alpha = highlighted ? 0.5 : 1.0
        }
    }
    
}
