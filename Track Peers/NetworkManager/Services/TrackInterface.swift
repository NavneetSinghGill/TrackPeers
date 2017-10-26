//
//  CategoryInterface.swift
//  Skeleton
//
//  Created by BestPeers on 05/06/17.
//  Copyright © 2017 BestPeers. All rights reserved.
//

import UIKit

class TrackInterface: Interface {
    
    public func postMyLocationWith(request: TrackRequest, completion: @escaping CompletionHandler) {
        interfaceBlock = completion
        RealAPI().getObject(request: request) { (success, response) in
            self.parseSuccessResponse(response:response as AnyObject)
        }
    }

    // MARK: Parse Response

    func parseSuccessResponse(response: AnyObject?) -> Void {
//        if validateResponse(response: response!){
//            var success: Bool = true
//            let responseDict = response as! Dictionary<String, Any>
//
//            let word:WordModel = WordModel()
//            word.word = responseDict["word"] as? String
//
//            switch request.wordInfoType
//            {
//            case .definitions:
//                word.definitions = responseDict["definitions"] as! Array<Dictionary<String, AnyObject>>
//            case .synonyms:
//                word.synonyms = responseDict["synonyms"] as! Array<String>
//            case .antonyms:
//                word.antonyms = responseDict["antonyms"] as! Array<String>
//            case .examples:
//                word.examples = responseDict["examples"] as! Array<String>
//            default:
//                success = false
//                print(Constants.kErrorMessage)
//            }
//
//            interfaceBlock!(success, word)
//        }
    }
}
