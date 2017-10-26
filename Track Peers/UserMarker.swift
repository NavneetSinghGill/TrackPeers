//
//  UserMarker.swift
//  Track Peers
//
//  Created by Navneet on 10/17/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import UIKit
import GoogleMaps

class UserMarker: GMSMarker {
    
    var radianAngle: CGFloat = 0
    var bearingAngle: CGFloat = 0
    var user: User?
    var followPolyline: GMSPolyline?
    
    func updateBearingWith(bearing: CGFloat) {
        bearingAngle = bearing
        self.iconView?.transform = CGAffineTransform(rotationAngle: radianAngle + bearing)
    }
    
    func updateBaseAngleWith(baseAngle: CGFloat) {
        radianAngle = baseAngle
        self.iconView?.transform = CGAffineTransform(rotationAngle: baseAngle + bearingAngle)
    }
    
    init(user: User) {
        self.user = user
    }

}
