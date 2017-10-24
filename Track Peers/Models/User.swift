//
//  User.swift
//  Track Peers
//
//  Created by Navneet on 10/23/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import UIKit
import MapKit

class User: NSObject {

    var latitude: Double?
    var longitude: Double?
    var lastLocation: CLLocationCoordinate2D?
    var traversedCoordinates: [CLLocationCoordinate2D] = []
    
    class func usersWithFakeLocations() -> [User] {
        var friends: [User] = []
        
        var friend = User()
        friend.lastLocation = CLLocationCoordinate2D(latitude: 22.744012459070447, longitude: 75.894027762115002)
        friends.append(friend)
        
        friend = User()
        friend.lastLocation = CLLocationCoordinate2D(latitude: 22.758893091919298, longitude: 75.891517214477062)
        friends.append(friend)
        
        friend = User()
        friend.lastLocation = CLLocationCoordinate2D(latitude: 22.750661452768234, longitude: 75.899842791259289)
        friends.append(friend)
        
        return friends
    }
}
