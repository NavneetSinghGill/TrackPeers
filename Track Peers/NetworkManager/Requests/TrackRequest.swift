//
//  WordRequest.swift
//  Skeleton
//
//  Created by Best Peers on 16/10/17.
//  Copyright © 2017 www.BestPeers.Skeleton. All rights reserved.
//

import UIKit

class TrackRequest: Request {
    
    
    func initPostMyLocationRequestWith(latLong:String) -> TrackRequest {
        parameters = ["latLong":latLong]
        urlPath = APIUrls.kPostMyLocation
        
        return self
    }
    
    func getCoordinatesOfFriend(with id:String) -> TrackRequest {
        parameters = ["friendId":id]
        urlPath = APIUrls.kGetFriendCoordinates
        
        return self
    }

}
