//
//  UploadVibeViewController.swift
//  CleverVibes
//
//  Created by Josh Safran on 4/19/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import Contentful


class UploadVibeViewController:UIViewController{
    var navController :UINavigationController?
    var uploadVibe = VibeObject()
    
    @IBOutlet weak var submittingLabel: UILabel!
    @IBOutlet weak var congratsLabel: UILabel!
//    let vibeKey =
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func setupWithVibeObject(obj:VibeObject){
        uploadVibe = obj
//        VibeUploadController.sharedInstance.uploadNewVibe(vibe: obj)
        uploadNewVibe()
    }
    
    
    @IBAction func didTapDone(_ sender: Any) {
        dismiss(animated: true) {
            self.navController?.popToRootViewController(animated: true)
        }
    }

    
    
    func uploadNewVibe(){
        let spaceId = GalleryDataSource.sharedInstance.contentfulSpaceId
        let accessToken = GalleryDataSource.sharedInstance.contentfulAccessToken
        let contentId = "vibeTest"
        
        let url = "https://api.contentful.com/spaces/\(spaceId)/entries"//?access_token=\(accessToken)"
        
//        /spaces/{space_id}/content_types
        let parameters = makeVibeJsonDict(obj: uploadVibe)
        
        var debugToken = VibeUploadController.sharedInstance.debugJoshToken
        let header = ["Authorization" : debugToken,
                      "Content-Type": "application/vnd.contentful.management.v1+json",
                      "X-Contentful-Content-Type":"vibe"]
        
//        Alamofire.request("\(url)5fJYjoInGgIcoa4EwcOSCK", method: .get, parameters: parameters, encoding: JSONEncoding.default, headers:header)
//            .responseJSON { response in
//                print(response.request as Any)  // original URL request
//                print(response.response as Any) // URL response
//                print(response.result.value as Any)   // result of response serialization
//        }
//        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.prettyPrinted, headers:header)
            .responseJSON { response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
                
                if let dict = response.result.value as? [String:Any]{
                    if let sysOptions = dict["sys"] as? [String:Any]{
                        if let idNum = sysOptions["id"] as? String{
                            ScoreController.shareScoreInstance.addPersonalVibe(vibeId: idNum);
                            self.publishNewVibeEntry(entryId: idNum);
                        }
                    }
                }
        }
    }
    
    func publishNewVibeEntry(entryId:String){
        
        let spaceId = GalleryDataSource.sharedInstance.contentfulSpaceId
        
        var debugToken = VibeUploadController.sharedInstance.debugJoshToken
        let header = ["Authorization" : debugToken,
                      "X-Contentful-Version": "1"]
        let parameters: [String:Any] = ["test":""]
        
        let targetURL = String("https://api.contentful.com/spaces/\(spaceId)/entries/\(entryId)/published")!;
        
        Alamofire.request(targetURL, method: .put, encoding: JSONEncoding.default, headers: header).responseJSON { response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)
            
            
            
                GalleryDataSource.sharedInstance.loadAllVibes()
                self.finishedUpload()
        }
        
        
    }
    
    func finishedUpload(){
        congratsLabel.isHidden = false;
        doneButton.isEnabled = true;
        submittingLabel.isHidden = true;
        activityIndicator.isHidden = true;
    }
    
    func makeVibeJsonDict(obj :VibeObject)->[String:Any]{
        var dict : [String:Any] = [:]
        
        dict = ["fields":[
                            "clue":["en-US":obj.clue],
                            "galleryName":["en-US":obj.galleryName],
                            "answerObjectNumber":["en-US":obj.answerObjectNumber]
                        ]
                ];
//            ["clue": [
//                            "value":obj.clue,
//                            "locale":"en-US"],
//                          "galleryName":["value":obj.galleryName],//["en-US":obj.galleryName],
//                          "answerObjectNumber":["value":obj.answerObjectNumber]]
//                "sys":["type":"Entry",
//                        "id":"vibe"]
//                ];
        return dict;
//        dict["fields"]
//        dict["fields"] : [String:Any] = [:]
//        dict["fields"]["clue"] = "Upload test"
//        dict["fields"]["galleryName"] = obj.galleryName
        
        
        
        
    }
    
}
