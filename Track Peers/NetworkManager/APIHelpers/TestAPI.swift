//
//  TestAPI.swift
//  Skeleton
//
//  Created by BestPeers on 01/06/17.
//  Copyright © 2017 BestPeers. All rights reserved.
//

import UIKit
import GoogleMaps

class TestAPI: NSObject, APIInteractor {
    func putObject(request: Request, completion: @escaping CompletionHandler) -> Void
    {
        completion(true, getResponse(forUrl: request.urlPath))
    }
    
    func getObject(request: Request, completion: @escaping CompletionHandler) -> Void
    {
        if request.urlPath == APIUrls.kGetFriendCoordinates {
            getResponse(forUrl: request.urlPath, completion: { (latLongs) in
                completion(true,latLongs)
            })
        } else {
            completion(true, getResponse(forUrl: request.urlPath))
        }
    }
    
    func postObject(request: Request, completion: @escaping CompletionHandler) -> Void
    {
        completion(true, getResponse(forUrl: request.urlPath))
    }
    
    func deleteObject(request: Request, completion: @escaping CompletionHandler) -> Void
    {
        completion(true, getResponse(forUrl: request.urlPath))
    }
    
    func multiPartObjectPost(request: Request, completion: @escaping CompletionHandler) -> Void
    {
        completion(true, getResponse(forUrl: request.urlPath))
    }
    
    //MARK: -
    
    func getResponse(forUrl: String) -> Dictionary<String, AnyObject> {
        var responseDict = Dictionary<String,AnyObject>()
        
        switch forUrl {
        case APIUrls.kPostMyLocation:
            return responseForPostMyLocation()
        default:
            responseDict["success"] = true as AnyObject
        }
        
        return responseDict
    }
    
    func getResponse(forUrl: String, completion: @escaping (_ response: AnyObject?) -> Void) {
        
        switch forUrl {
        case APIUrls.kGetFriendCoordinates:
            getCoordinatesOfFriend(completion: { (latLongs) in
                completion(latLongs)
            })
        default:
            break
        }
    }
    
    func responseForPostMyLocation() -> Dictionary<String,AnyObject> {
        let responseDict = Dictionary<String,AnyObject>()
        
        return responseDict
    }
    
    func getCoordinatesOfFriend(completion: @escaping (_ response: AnyObject?) -> Void) {
        var responseDict = Dictionary<String,AnyObject>()
        
//        let originLat  = Float(arc4random_uniform(1500000)) * Float(0.00000001) + 22.74
//        let originLong = Float(arc4random_uniform(1000000)) * Float(0.00000001) + 75.89
//        let originLocation = CLLocation(latitude: CLLocationDegrees(originLat), longitude: CLLocationDegrees(originLong))
//
//        let destinationLat = Float(arc4random_uniform(1500000)) * Float(0.00000001) + 22.73
//        let destinationLong = Float(arc4random_uniform(1000000)) * Float(0.00000001) + 75.88
//        let destinationLocation = CLLocation(latitude: CLLocationDegrees(destinationLat), longitude: CLLocationDegrees(destinationLong))
        
        let originLocation = CLLocation(latitude: CLLocationDegrees(22.74569), longitude: CLLocationDegrees(75.893689))
        let destinationLocation = CLLocation(latitude: CLLocationDegrees(22.758948), longitude: CLLocationDegrees(75.897787))
        
        
        var latLongs = Array<String>()
        
        Global.global.fetchPolylineWithOrigin(origin: originLocation, destination: destinationLocation) { (polyline) in
            print("OriginLoc: \(originLocation), DestinationLoc: \(destinationLocation), Polyline: \(String(describing: polyline))")
            if polyline != nil {
                for i in 0..<(polyline?.path?.count())! {
                    let coordinate = polyline?.path?.coordinate(at: i)
                    latLongs.append("\((coordinate?.latitude)!),\((coordinate?.longitude)!)")
                }
            }
            responseDict["latLongs"] = latLongs as AnyObject
            responseDict["success"] = true as AnyObject
            completion(responseDict as AnyObject)
        }
        
//        return responseDict
    }
}
