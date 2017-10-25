//
//  MultiPolyline.swift
//  Track Peers
//
//  Created by Navneet on 10/25/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import UIKit
import GoogleMaps

class MultiPolyline: NSObject {
    
    var allPaths: [GMSPath] = []
    var allPolylines: [GMSPolyline] = [] {
        willSet {
            
        }
    }
    
    func add(polyine: GMSPolyline) {
        allPolylines.append(polyine)
    }
    
    func addPolyline(with path: GMSPath) {
        allPolylines.append(GMSPolyline(path: path))
    }
    
    func drawPolylinesOnMap(mapView: GMSMapView) {
        for polyline in allPolylines {
            polyline.map = mapView
        }
    }
    
}
