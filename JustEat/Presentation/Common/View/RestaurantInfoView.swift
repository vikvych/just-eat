//
//  RestaurantInfoView.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 6/1/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import UIKit
import Cosmos

private let placeholderImage = #imageLiteral(resourceName: "logo_placeholder")

class RestaurantInfoView: UIView {

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cousineTypesLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var ratingViewHolder: UIView!

    lazy var ratingView: CosmosView = {
        let ratingView = CosmosView(frame: ratingViewHolder.bounds)
        
        ratingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        ratingView.backgroundColor = .clear
        ratingView.settings.updateOnTouch = false
        ratingView.settings.emptyBorderColor = .accent
        ratingView.settings.filledBorderColor = .accent
        ratingView.settings.filledColor = .accent
        ratingView.settings.fillMode = .precise
        ratingView.settings.starMargin = 2.0
        ratingView.settings.starSize = 16.0
        ratingView.settings.totalStars = 6
        
        return ratingView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        ratingViewHolder.addSubview(ratingView)
    }
    
}

extension RestaurantInfoView {
    
    func setup(with item: Restaurant) {
        nameLabel.text = item.name
        ratingView.rating = item.ratingStars
        ratingView.text = String(item.ratingStars)
        cousineTypesLabel.text = item.cuisineTypes.map({ $0.name }).joined(separator: " ,")
        statusLabel.isHidden = !item.isOpenNow
        logoView.image = placeholderImage
        
        if let url = item.logo.first?.url {
            logoView.af_setImage(withURL: url, imageTransition: UIImageView.ImageTransition.crossDissolve(0.2))
        }
    }
    
}
