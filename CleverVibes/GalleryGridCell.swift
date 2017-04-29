//
//  GalleryGridCell.swift
//  SubtleVibes
//
//  Created by Josh Safran on 4/13/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import UIKit

//class GalleryConfig{
//    var
//}


class GalleryGridCell: UICollectionViewCell{
    
    @IBOutlet weak var galleryNumber: UILabel!
    @IBOutlet weak var descriptorLabel: UILabel!
    @IBOutlet weak var vibeIndicator: UIImageView!
    
    @IBOutlet weak var badgeNumberLabel: UILabel!
    
    var galleryName = "default"
//    var galleryNumber = "000"
    var galleryDescription = "default type"
    
    
    func setupWithGallery(galleryName:String, description:String,  unsolvedVibeNumber:Int){
        self.galleryName = galleryName
        galleryDescription = description;
        
        var numString = galleryName
        
        if let galleryPrefixRange = numString.range(of: "Gallery ") {
            numString.replaceSubrange(galleryPrefixRange, with: "")
        }
        galleryNumber.text = numString;
        
        vibeIndicator.isHidden = unsolvedVibeNumber <= 0;
        badgeNumberLabel.isHidden = unsolvedVibeNumber <= 0;
        
        badgeNumberLabel.text = "\(unsolvedVibeNumber)";

        
        
    }
    
    
    
    
}
