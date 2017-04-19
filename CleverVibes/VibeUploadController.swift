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
    
    
    
    func UpdateCorrectAnswerCountForVibe(vibe : VibeObject ){
        
    }
    
    func UpdateIncorrectAnswerCountForVibe(vibe:VibeObject){
        
    }
    
    
    
    func uploadNewVibe(vibe:VibeObject){
        // PUT
        // /spaces/yadj1kx9rmg0/content_types/2PqfXUJwE8qSYKuM0U6w8M
        
        
        
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
