//
//  BeaconGalleryMapping.swift
//  CleverVibes
//
//  Created by Josh Safran on 5/2/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation

class BeaconGalleryMapping{
    var major = 0
    var minor = 0
    var uuid = ""
    var galleryNumber = 0
    
    init(config:[String:Any], galleryNum:Int){
        if let majorNum = config["major"] as? Int{
            major = majorNum;
        }
        if let minorNum = config["minor"] as? Int{
            minor = minorNum;
        }
        if let idNum = config["UUID"] as? String{
            uuid = idNum;
        }
        
        galleryNumber = galleryNum;
        
    }
    
}
