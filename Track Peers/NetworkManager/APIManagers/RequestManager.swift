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
    func postMyLocation(encodedPath:String, completion:@escaping CompletionHandler){
        if appDelegate.isNetworkAvailable {
            TrackInterface().postMyLocationWith(request: TrackRequest().initPostMyLocationRequestWith(encodedPath: encodedPath), completion: completion)
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
}
