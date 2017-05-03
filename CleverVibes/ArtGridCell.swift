//
//  ArtGridCell.swift
//  CleverVibes
//
//  Created by Josh Safran on 4/14/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage


class ArtGridCell:UICollectionViewCell{
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    @IBOutlet weak var objectNumberLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func setupWithImageURL(url:String){
        thumbnailImage.image = nil;
        activityIndicator.startAnimating()
//        self.thumbnailImage.image = UIImage(named: "thinker");
        Alamofire.request(url).responseImage { response in
//            debugPrint(response)
//
//            print(response.request)
//            print(response.response)
//            debugPrint(response.result)
//            
            if let image = response.result.value {
                self.activityIndicator.stopAnimating()
//                print("image downloaded: \(image)")
//                var image = UIImage(data: imageData)
                if(self.thumbnailImage != nil){
                    self.thumbnailImage.image = image;
                }else{
                    print("Missing thumbnail reference");
                }
                
            }
        }
    }
    
    
    
    
}
