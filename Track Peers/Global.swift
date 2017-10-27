//
//  Global.swift
//  Track Peers
//
//  Created by Navneet on 10/24/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import UIKit
import GoogleMaps

class Global: NSObject {
    
    static let global = Global()

    class func fill(color: UIColor, inImageView: UIImageView) {
        let templateImage = inImageView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        inImageView.image = templateImage
        inImageView.tintColor = color
    }
    
    func getCLLocationCoordinate2DArray(forLatLongStringArray: Array<String>) -> Array<CLLocationCoordinate2D> {
        var locations = Array<CLLocationCoordinate2D>()
        for latLong in forLatLongStringArray {
            let latLongArray = latLong.characters.split{$0 == ","}.map(String.init)
            locations.append(CLLocationCoordinate2D(latitude: Double(latLongArray[0])!, longitude: Double(latLongArray[1])!))
        }
        return locations
    }
    
    func fetchPolylineWithOrigin(origin: CLLocation, destination: CLLocation, completionHandler: @escaping ((_ polyline: GMSPolyline?) -> Void)) {
        let originString = "\(origin.coordinate.latitude),\(origin.coordinate.longitude)"
        let destinationString = "\(destination.coordinate.latitude),\(destination.coordinate.longitude)"
        let directionsAPI = "https://maps.googleapis.com/maps/api/directions/json?"
        let directionsUrlString = "\(directionsAPI)&origin=\(originString)&destination=\(destinationString)&mode=driving"
        let directionsUrl = URL(string: directionsUrlString)
        
        let request = URLRequest(url: directionsUrl!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    if (error != nil) {
                        completionHandler(nil)
                        return
                    }
                    
                    let routesArray: Array<AnyObject> = (json as! Dictionary<String, AnyObject>)["routes"] as! Array<AnyObject>
                    var polyline: GMSPolyline? = nil
                    
                    if routesArray.count > 0 {
                        let routeDict: Dictionary<String,AnyObject> = routesArray[0] as! Dictionary<String, AnyObject>
                        let routeOverviewPolyline: Dictionary<String, AnyObject> = routeDict["overview_polyline"] as! Dictionary<String, AnyObject>
                        let points: String = routeOverviewPolyline["points"] as! String
                        let path: GMSPath = GMSPath(fromEncodedPath: points)!
                        polyline = GMSPolyline(path: path)
                        polyline?.strokeWidth = 2
                        polyline?.strokeColor = followUserColor
                    }
                    
                    DispatchQueue.main.async {
                        completionHandler(polyline)
                    }
                } catch _ {
                    
                }
                
            }
        }
        
        task.resume()
    }
}
