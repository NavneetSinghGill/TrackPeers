//
//  Constants.swift
//  Track Peers
//
//  Created by Navneet on 10/13/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

let loggedInUserPathColor = UIColor.black

#if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
    let isSimulator = true
#else
    let isSimulator = false
#endif
