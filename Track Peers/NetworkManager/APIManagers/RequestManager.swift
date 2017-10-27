//
//  RequestManager.swift
//  Skeleton
//
//  Created by BestPeers on 05/06/17.
//  Copyright © 2017 BestPeers. All rights reserved.
//

import UIKit

class RequestManager: NSObject {
    
    //MARK: Post location API
    func postMyLocation(latLong:String, completion:@escaping CompletionHandler) {
        if appDelegate.isNetworkAvailable {
            TrackInterface().postMyLocationWith(request: TrackRequest().initPostMyLocationRequestWith(latLong: latLong), completion: completion)
        } else {
            completion(false, Constants.kNoNetworkMessage)
            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
    func getCoordinatesOfFriend(of id:String, completion:@escaping CompletionHandler) {
        if appDelegate.isNetworkAvailable {
            TrackInterface().getCoordinatesOfFriendWith(request: TrackRequest().getCoordinatesOfFriend(with: id), completion: completion)
        } else {
            completion(false, Constants.kNoNetworkMessage)
            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
}
