//
//  VibeTableViewController.swift
//  CleverVibes
//
//  Created by Josh Safran on 4/18/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import UIKit

class VibeTableViewController:UITableViewController{
    
    var vibeList : [VibeObject] = []
    
    var displayedList : [VibeObject] = []
    
    var galleryName = ""
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        
        setupData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupData()
    }
    
    func setupData(){
        
    }
    
    func selectAndSortDisplayedList(){
        
    }
    
    func setupWithGalleryName(galleryName:String){
        self.galleryName = galleryName
//        vibeList = GalleryDataSource.sharedInstance.allVibesFor(gallery: galleryName)//
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vibeList.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var reuseCell = tableView.dequeueReusableCell(withIdentifier: "vibeCell")
        if(reuseCell == nil){
            reuseCell = UITableViewCell(style: .subtitle, reuseIdentifier: "vibeCell")
        }
        
        if(indexPath.row < vibeList.count){
            let vibe = vibeList[indexPath.row];
            reuseCell?.textLabel?.text = vibe.clue;
            reuseCell?.textLabel?.textColor = UIColor.black;
        }else{
            reuseCell?.textLabel?.text = "ADD YOUR OWN VIBE"
            reuseCell?.textLabel?.textColor = UIColor.lightGray;
        }
        
        
//        reuseCell?.detailTextLabel?.text = "\() pieces of art";
        
        return reuseCell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row<vibeList.count){
            print("selected \(vibeList[indexPath.row].clue)");
        
            if let vc = storyboard?.instantiateViewController(withIdentifier: "VibeDisplayScreen") as? VibeDisplayViewController{
                
                
                vc.setupWith(vibe: vibeList[indexPath.row])
                
                navigationController?.show(vc, sender: nil);
            }
        }else{
            print("Selected Make A new Vibe");
            
            if let vc = storyboard?.instantiateViewController(withIdentifier: "VibeWriteScreen") as? VibeWriteViewController{
                
                vc.setupWithGalleryName(name: galleryName)
                
                navigationController?.pushViewController(vc, animated: true);
            }
            
            
            
        }
        
        
        
        
    }
    
    
    
}
