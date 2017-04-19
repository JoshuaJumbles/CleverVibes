//
//  GalleryTableViewController.swift
//  CleverVibes
//
//  Created by Josh Safran on 4/14/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import UIKit

class GalleryTableViewController:UITableViewController{
    
    var galleryCounts : [String:Int] = [:]
    var galleryVibeCounts : [String:Int] = [:]
    var galleryKeys : [String] = []
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        
        setupData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        GalleryDataSource.sharedInstance.loadAllVibes()
//        setupData()
//        
//        tableView.reloadData()
    }
    
    func setupData(){
        galleryCounts = GalleryDataSource.sharedInstance.galleryArtCounts();
        galleryVibeCounts = GalleryDataSource.sharedInstance.galleryVibeCounts();
        galleryKeys = Array(galleryCounts.keys);
        galleryKeys.sort() //{ $0.Name < $1.Name }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return galleryKeys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var reuseCell = tableView.dequeueReusableCell(withIdentifier: "galleryCell")
        if(reuseCell == nil){
            reuseCell = UITableViewCell(style: .subtitle, reuseIdentifier: "galleryCell")
        }
        let keyName = galleryKeys[indexPath.row];
        reuseCell?.textLabel?.text = keyName;
        let vibeCount = (galleryVibeCounts.keys.contains(keyName)) ? galleryVibeCounts[keyName]! : 0;
        var vibeLanguage = (vibeCount == 1) ? "1 vibe, " : "\(vibeCount) vibes, "
        if(vibeCount == 0){
            vibeLanguage = ""
        }
        reuseCell?.detailTextLabel?.text = "\(vibeLanguage)\(galleryCounts[keyName]!) pieces of art";
        
        reuseCell?.textLabel?.textColor = (vibeCount == 0) ? UIColor.gray : UIColor.green;
        reuseCell?.detailTextLabel?.textColor = (vibeCount == 0) ? UIColor.lightGray : UIColor.black;
        
   
        
        return reuseCell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(galleryKeys[indexPath.row])");
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "VibeTableScreen") as? VibeTableViewController{
            
            
            vc.setupWithGalleryName(galleryName: galleryKeys[indexPath.row]);
            
            navigationController?.show(vc, sender: nil);
        }
        
        
        
        
    }
    
    
    
}
