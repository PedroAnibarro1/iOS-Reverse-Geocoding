//
//  CurrentLocationButton.swift
//  Reverse Geocoding
//
//  Created by Pedro Anibarro on 6/21/18.
//  Copyright © 2018 ErraticMinds. All rights reserved.
//

import UIKit

class CurrentLocationButton: UIButton {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.layer.cornerRadius = 10.0
        self.setTitle(nil, for: .normal)
        self.setImage(GeocodingStyleKit.imageOfLocationIcon, for: .normal)
        self.setImage(GeocodingStyleKit.imageOfLocationIconSelected, for: .selected)
    }
 

}
