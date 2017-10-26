//
//  WordRequest.swift
//  Skeleton
//
//  Created by Best Peers on 16/10/17.
//  Copyright © 2017 www.BestPeers.Skeleton. All rights reserved.
//

import UIKit

class TrackRequest: Request {
    
    
    func initPostMyLocationRequestWith(encodedPath:String) -> TrackRequest {
        urlPath = "/location"
        return self
    }

}
