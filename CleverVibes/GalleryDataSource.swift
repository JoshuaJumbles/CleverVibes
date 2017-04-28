//
//  GalleryDataSource.swift
//  SubtleVibes
//
//  Created by Josh Safran on 4/11/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import Alamofire
import Sync


class GalleryDataSource {
    static let sharedInstance = GalleryDataSource()
    
    let pageCount = 500;
    let hardCodedLimit = 7500;
    var totalOffset = 0;
    
    let file = "Resources/LocalAPIData.json"
    
    var dataStack:DataStack;
    var fullPayload : [[String:Any]]
    
    var loadedData : [ArtObject]
    var imageURLPerRoom : [String:[String]]
    
    var loadedVibes : [VibeObject] = []
    
    let contentfulSpaceId = "dnednuw2i49p";
    let contentfulAccessToken = "34ed7ab08c1d6ab8d56318f6629180133c0ca04b52566f394a7009b7bea80efd"
    
    var collectionRefreshDelegate : GalleryCollectionViewController?
    var highScoreRefreshDelegate : ScoreTableViewController?
    
    let selectedRoomFilter = [258,264,262,250,217,218,219,205];
    var useFilter = true;
    
    
    
    
    init(){
        dataStack = DataStack(modelName:"CleverVibes");
        fullPayload = [[:]]
        loadedData = []
        
        imageURLPerRoom = [:]
        
        loadDataFromLocalJSON();
        loadAllVibes();
//        ScoreController.sharedInstance;
    }
    
    func loadDataFromLocalJSON(){
        do{
            let mainBundle = Bundle.main
            if let dir = mainBundle.url(forResource: "strippedDataFull", withExtension: ".json"){
                var data = try Data(contentsOf :dir)
                let jsonTest = JSONSerialization.isValidJSONObject(data);
                let jsonWithObjectRoot = try? JSONSerialization.jsonObject(with: data, options: [])
                
                
                if let dictionaryList = jsonWithObjectRoot as? [[String: Any]] {
//                    print(dictionaryList)
//                    loadedData = dictionaryList
                    for dictionary in dictionaryList{
                        let artObject = ArtObject(config: dictionary)
                        
                        if(useFilter){
                            for selectRoom in selectedRoomFilter{
                                if(artObject.galleryName.contains("Gallery \(selectRoom)")){
                                    loadedData.append(artObject);
                                }
                            }
                        }else{
                            loadedData.append(artObject);
                        }
                        
                        
                        
                    }
                }
                
                
            }
        }catch{
            print(error);
        }

    }
    
    func loadAllVibes(){
        do{
            
            let url = "https://cdn.contentful.com/spaces/\(contentfulSpaceId)/entries?access_token=\(contentfulAccessToken)";
            Alamofire.request(url).responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // HTTP URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value as? [String:Any] {
                    print("JSON: \(JSON)")
                    if let itemList = JSON["items"] as? [[String:Any]]{
                        self.loadedVibes = []
                        for item in itemList{
                            var vibeObject : VibeObject?
                            var uuid = ""
                            var version = 0;
                            if let sys = item["sys"] as? [String:Any]{
                                if let id = sys["id"] as? String{
                                    uuid = id;
                                }
                                if let revisionNum = sys["revision"] as? Int{
                                    version = revisionNum;
                                }
                            }
                            if let fields = item["fields"] as? [String:Any]{
                                
                                
                                vibeObject = VibeObject(config: fields, uuid: uuid, versionNumber: version)
//                                print("FIELDS:\(fields)");
                                
                                
                            }
                            
                            
                            if(vibeObject != nil){
                                self.loadedVibes.append(vibeObject!)
                            }
                            
                        }
                        
                        if(self.collectionRefreshDelegate != nil){
                            self.collectionRefreshDelegate!.reloadData()
                        }
                        if(self.highScoreRefreshDelegate != nil){
                            self.highScoreRefreshDelegate!.dataSourceDidReload()
                        }
                    }
                }
            }
            
        }catch{
            print(error);
        }
    }
    
    func objectForId(objectNum:Int)->ArtObject?{
        for obj in loadedData{
            if(obj.objectNumber == objectNum){
                return obj;
            }
        }
        return nil;

    }
    
    
    
    func allObjectsFor(gallery galleryName:String)->[ArtObject]{
        var objList : [ArtObject] = [];
        for artObj in loadedData{
            if(artObj.galleryName == galleryName){
                objList.append(artObj)
            }
        }

        return objList;
    }
    
    func allVibesFor(gallery galleryName:String)->[VibeObject]{
        var vibeList:[VibeObject] = []
        for vibe in loadedVibes{
            if(vibe.galleryName == galleryName){
                vibeList.append(vibe)
            }
        }
        return vibeList
    }
    
    
    func galleryArtCounts() -> [String:Int]{
        var galleryList : [String:Int] = [:];
        
        for artObj in loadedData{
            let galleryName = artObj.galleryName;
            if(!galleryList.keys.contains(galleryName)){
                galleryList[galleryName] = 1;
            }else{
                galleryList[galleryName] = galleryList[galleryName]! + 1;
            }
        }
        return galleryList
    }
    
    func galleryFreshVibes() -> [String:[String]]{
        var galleryList : [String:[String]] = [:];
        
        var used = ScoreController.shareScoreInstance.getUsedVibes()
        var personal = ScoreController.shareScoreInstance.getPersonalVibes()
        
        for vibe in loadedVibes{
            let galleryName = vibe.galleryName;
            if(used.contains(vibe.uuid)){
                continue;
            }
            if(personal.contains(vibe.uuid)){
                continue;
            }
            
            if(!galleryList.keys.contains(galleryName)){
                galleryList[galleryName] = [vibe.uuid];
            }else{
                
                if(!galleryList[galleryName]!.contains(vibe.uuid)){
                    galleryList[galleryName]?.append(vibe.uuid) ;
                }
            }
        }
        return galleryList
    }
    
    func freshVibesForList(vibeList:[VibeObject], useFresh:Bool)->[VibeObject]{
        var returnList :[VibeObject] = []
        
        var used = ScoreController.shareScoreInstance.getUsedVibes()
        var personal = ScoreController.shareScoreInstance.getPersonalVibes()
        
        for vibe in vibeList{
            let galleryName = vibe.galleryName;
            if(used.contains(vibe.uuid)){
                if(!useFresh){
                    returnList.append(vibe)
                }
                continue;
            }
            if(personal.contains(vibe.uuid)){
                if(!useFresh){
                    returnList.append(vibe)
                }
                continue;
            }
            
            if(vibe.isVotedRude()){
                continue;
            }
            
            if(useFresh){
                returnList.append(vibe)
            }
            
        }
        return returnList
    }
    
    
    
    func startSyncingDatabaseToLocalJSON(){
        do{
            let mainBundle = Bundle.main
            if let dir = mainBundle.url(forResource: "strippedData", withExtension: ".json"){
                var data = try Data(contentsOf :dir)
                let jsonTest = JSONSerialization.isValidJSONObject(data);
                let jsonWithObjectRoot = try? JSONSerialization.jsonObject(with: data, options: [])
                
                
                if let dictionaryList = jsonWithObjectRoot as? [[String: Any]] {
                    print(dictionaryList)
                }

                
            }
        }catch{
            print(error);
        }

        
        
    }


    
    func readFileText()->String{
        let mainBundle = Bundle.main
        if let dir = mainBundle.url(forResource: "SyncDemoTest", withExtension: ".json"){
        // mainBundle.path(forResource: "LocalAPIData", ofType: ".json"){//FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
//            let path = dir.appendingPathComponent(file)
//            let url = URL(string: dir)!
            //reading
            do {
                return try String(contentsOf: dir, encoding: String.Encoding.utf8)
            }
            catch {/* error handling here */
                return "";
            
            }
        }else{
            return "";
        }
    }
    
    func startDownloadingAllObjects(){
        DownloadTestObjectPool(offset: 0);
    }
    
    
    func DownloadTestObjectPool(offset:Int){

        
        print("Requesting Objects, offset-\(offset)");
        
        let testURL = "https://hackathon.philamuseum.org/api/v0/collection/objectsOnView?limit=\(pageCount)&offset=\(offset)&api_token=C3XAu0Sgmrllig0aYGmS46LVfvCt0elxHP1gGWYOJZHFJQpW3kLgXybPni5G"
        
        Alamofire.request(testURL).responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // HTTP URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
            
//            fullPayload = [[:]]
            if let JSON = response.result.value {
                do{
                    let data1 =  try JSONSerialization.data(withJSONObject: JSON, options: []);//JSONSerialization.WritingOptions.prettyPrinted)//JSONSerialization.WritingOptions.)// (JSON, options: NSJSONWritingOptions.PrettyPrinted) // first of all convert json to the data
                    
                    let jsonWithObjectRoot = try? JSONSerialization.jsonObject(with: data1, options: [])
                    
                    
                    if let dictionaryList = jsonWithObjectRoot as? [[String: Any]] {
                        
                        for dictionary in dictionaryList{
                            var strippedDictionary :[String:Any]
                            strippedDictionary = [:]
                            if let uId = dictionary["ObjectID"] as? Int{
                                strippedDictionary["ObjectID"] = uId;
                            }
                            if let thumbnailURL = dictionary["Image"] as? String{
                                strippedDictionary["Image"] = thumbnailURL;
                            }
                            if let thumbnailURL = dictionary["Thumbnail"] as? String{
                                strippedDictionary["Thumbnail"] = thumbnailURL;
                            }
                            if let location = dictionary["Location"] as? [String:Any]{
                                if let galleryId = location["GalleryShort"] as? String{
                                    strippedDictionary["GalleryShort"] = galleryId;
                                }
                            }
                            self.fullPayload.append(strippedDictionary);
                        }

                    }

                }catch let myJSONError {
                    print(myJSONError)
                }
                
                self.totalOffset += self.pageCount;
                if(self.totalOffset < self.hardCodedLimit){
                    self.DownloadTestObjectPool(offset: self.totalOffset);
                }else{
//                    print("FINISHED");
                    do{
                        let data2 =  try JSONSerialization.data(withJSONObject: self.fullPayload, options: []);
                        let stringPresentation = String(data: data2, encoding: String.Encoding.utf8)
//                        print(stringPresentation);
                    }catch{
                        print("Error on final print")
                    }
                }
            }
            
            
            
        }
    }
}
