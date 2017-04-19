//
//  ArtObject.swift
//  CleverVibes
//
//  Created by Josh Safran on 4/18/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation

class ArtObject{
    var thumbnailURL = "";
    var fullURL = "";
    var objectNumber = -1;
    var galleryName = "";
    
    init(){
        
    }
    
    init(config:[String:Any]){
        if let galleryKey = config["GalleryShort"] as? String{
            galleryName = galleryKey
        }
        if let url = config["Thumbnail"] as? String{
            thumbnailURL = url;
        }
        if let url = config["Image"] as? String{
            fullURL = url
        }
        if let num = config["ObjectID"] as? Int{
            objectNumber = num
        }
    }
}
