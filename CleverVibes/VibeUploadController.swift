//
//  VibeUploadController.swift
//  CleverVibes
//
//  Created by Josh Safran on 4/19/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import Alamofire


class VibeUploadController{
    
    static let sharedInstance = VibeUploadController()
    //logged in as josh for testing
    //This access token should only be used for learning and testing purposes. Please create a separate OAuth application for production usage.
    let debugJoshToken = "Bearer 728a2bd8903f6eabf3396051175d3a8909533a2cfd0507a06e3102f9176f712c"
    
    
    //first contenful users need to go to a web page to authorize contentful
    //https://be.contentful.com/oauth/authorize?response_type=token&client_id=$YOUR_APPS_CLIENT_ID&redirect_uri=$YOUR_APPS_REDIRECT_URL&scope=content_management_manage

    //Then it will redirect back to the app
    
    
    
//    func UpdateCorrectAnswerCountForVibe(vibe : VibeObject ){
//        
//    }
//    
//    func UpdateIncorrectAnswerCountForVibe(vibe:VibeObject){
//        
//    }
    
    static func UploadChangedVibeObject(vibe : VibeObject){
        
    }
    
    
    
    
    static func makeVibeJsonDict(obj :VibeObject)->[String:Any]{
        var dict : [String:Any] = [:]
        
        dict = ["fields":[
            "clue":["en-US":obj.clue],
            "galleryName":["en-US":obj.galleryName],
            "answerObjectNumber":["en-US":obj.answerObjectNumber],
            "correctAnswers":["en-US":obj.correctAnswers],
            "incorrectAnswers":["en-US":obj.incorrectAnswers],
            "lameVotes":["en-US":obj.lameVotes],
            "cleverVotes":["en-US":obj.cleverVotes]
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
    
    static func uploadVibeChanges(vibe:VibeObject, isPersonalVibe:Bool){
        let spaceId = GalleryDataSource.sharedInstance.contentfulSpaceId
        
        var debugToken = VibeUploadController.sharedInstance.debugJoshToken
        
        let header = ["Authorization" : debugToken];
        let targetURL = String("https://api.contentful.com/spaces/\(spaceId)/entries/\(vibe.uuid)");
        Alamofire.request(targetURL, method: .get,parameters:nil, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            print(response.request as Any)  // original URL request
            print(response.response as Any) // URL response
            print(response.result.value as Any)

            if let dict = response.result.value as? [String:Any]{
                if let sysOptions = dict["sys"] as? [String:Any]{
                    var version = 0;
                    
                    if let revision = sysOptions["version"] as? Int{
                        version = revision;
                    }
                    
                    self.uploadVibeChangesWithVersion(vibe: vibe, versionNumber: version,isPersonalVibe: isPersonalVibe);
                }
            }

                
            }
    }
    
    static func uploadVibeChangesWithVersion(vibe:VibeObject, versionNumber:Int, isPersonalVibe:Bool){
        let spaceId = GalleryDataSource.sharedInstance.contentfulSpaceId
        
        var debugToken = VibeUploadController.sharedInstance.debugJoshToken
        
        let header = ["Authorization" : debugToken,
                      "Content-Type": "application/vnd.contentful.management.v1+json",
                      "X-Contentful-Version":"\(versionNumber)"]
        
        let parameters: [String:Any] = makeVibeJsonDict(obj: vibe);
        
        let targetURL = String("https://api.contentful.com/spaces/\(spaceId)/entries/\(vibe.uuid)");
        
        Alamofire.request(targetURL, method: .put,parameters:parameters, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            print(response.request as Any)  // original URL request
            print(response.response as Any) // URL response
            print(response.result.value as Any)
            if let dict = response.result.value as? [String:Any]{
                if let sysOptions = dict["sys"] as? [String:Any]{
                    var id = "";
                    var version = 0;
                    if let idNum = sysOptions["id"] as? String{
                        id = idNum;
                    }
                    if let revision = sysOptions["version"] as? Int{
                        version = revision;
                    }
                    if(isPersonalVibe){
                        ScoreController.shareScoreInstance.addPersonalVibe(vibeId: id);
                    }else{
                        ScoreController.shareScoreInstance.addUsedVibe(vibeId: id);
                    }
                    
                    VibeUploadController.publishVibeEntry(entryId: id, version: version, onCompletion: {
                        GalleryDataSource.sharedInstance.loadAllVibes()
                    })
                }
            }
            
//            self.finishedUpload()
        }
    }
    
    static func publishVibeEntry(entryId:String, version:Int, onCompletion:@escaping () -> Void){
        
        let spaceId = GalleryDataSource.sharedInstance.contentfulSpaceId
        
        var debugToken = VibeUploadController.sharedInstance.debugJoshToken
        let header = ["Authorization" : debugToken,
                      "X-Contentful-Version": "\(version)"]
//        let parameters: [String:Any] = ["test":""]
        
        let targetURL = String("https://api.contentful.com/spaces/\(spaceId)/entries/\(entryId)/published");
        
        Alamofire.request(targetURL, method: .put, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            print(response.request as Any)  // original URL request
            print(response.response as Any) // URL response
            print(response.result.value as Any)
            
            
            
            GalleryDataSource.sharedInstance.loadAllVibes()
//            self.finishedUpload()
            onCompletion();
        }
        
        
    }

    
    
//    Updating content
//    Contentful doesn't merge changes made to content, so when updating content, you need to send the entire body of an entry. If you update content with a subset of properties, you will lose all existing properties not included in that update.
//    You should always update resources in the following order:
//    Fetch current resource.
//    Make changes to the current resource.
//    Update the resource by passing the changed resource along with current version number.
    
    
//    Updating and version locking
//    Contentful uses optimistic locking. When updating an existing resource, you need to specify its current version with the X-Contentful-Version HTTP header (this header is automatically set when using our official SDKs). Contentful compares this version with the current version stored to ensure that a client doesn't overwrite a resource that has since been updated. If the version changed in-between, Contentful would reject the update.
    
}
