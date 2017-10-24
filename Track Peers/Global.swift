//
//  Global.swift
//  Track Peers
//
//  Created by Navneet on 10/24/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import UIKit

class Global: NSObject {

    class func fill(color: UIColor, inImageView: UIImageView) {
        let templateImage = inImageView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        inImageView.image = templateImage
        inImageView.tintColor = color
    }
}
