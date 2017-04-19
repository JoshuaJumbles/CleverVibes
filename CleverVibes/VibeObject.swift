//
//  VibeObject.swift
//  CleverVibes
//
//  Created by Josh Safran on 4/18/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation

class VibeObject{
    
    var clue = "Default Clue Text?!";
    var createdAtDate = Date(timeIntervalSince1970: 0)
    var answerObjectNumber = 0
    var galleryName = ""
    
    var configDict :[String:Any] = [:]
    
    init(){
        
    }
    
    init(config:[String:Any]){
        configDict = config;
        
        if let str = config["clue"] as? String{
            clue = str
        }
        if let url = config["galleryName"] as? String{
            galleryName = url
        }
        if let num = config["answerObjectNumber"] as? Int{
            answerObjectNumber = num
        }
    }
    
}
