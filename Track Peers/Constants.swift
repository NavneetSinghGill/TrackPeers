//
//  Constants.swift
//  Track Peers
//
//  Created by Navneet on 10/13/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate
typealias CompletionHandler = (_ success: Bool, _ response: Any?) -> Void

#if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
let isSimulator = true
#else
let isSimulator = false
#endif

let testEnvironmentURLs = ["a"]

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

let loggedInUserPathColor = UIColor.black
let followUserColor = UIColor.green

//MARK: User defaults

let kMyEncodedPath = "kMyEncodedPath"
let kMyMultiPolyline = "kMyMultiPolyline"

struct Constants {
    
    // MARK: General Constants
    static let DeviceTokenKey = "device_token"
    static let DeviceInfoKey = "device_info"
    static let DeviceTypeKey = "device_type"
    static let EmptyString = ""
    static let kErrorMessage = "Something went wrong while processing your request"
    static let kNoNetworkMessage = "No network available"
    
    // MARK: User Defaults
    static let UserDefaultsDeviceTokenKey = "DeviceTokenKey"
    
    // MARK: Enums
    enum RequestType: NSInteger {
        case GET
        case POST
        case MultiPartPost
        case DELETE
        case PUT
    }
    
    // MARK: Numerical Constants
    static let StatusSuccess = 1
    static let ResponseStatusSuccess = 200
    static let ResponseStatusCreated = 201
    static let ResponseStatusAccepted = 202
    static let ResponseStatusForbidden = 401
    
    // MARK: Network Keys
    static let InsecureProtocol = "http://"
    static let SecureProtocol = "https://"
    static let LocalEnviroment = "LOCAL"
    static let StagingEnviroment = "STAGING"
    static let LiveEnviroment = "LIVE"
}
