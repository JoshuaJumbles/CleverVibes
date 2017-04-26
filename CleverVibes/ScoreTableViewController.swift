//
//  ScoreTableViewController.swift
//  CleverVibes
//
//  Created by Josh Safran on 4/24/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import UIKit

class ScoreTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var vibeList : [VibeObject] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        vibeList = GalleryDataSource.sharedInstance.loadedVibes;
        
        let cellXib = UINib.init(nibName: "VibeTableCell", bundle: Bundle.main)
//        tableView?.register(cellXib, forCellWithReuseIdentifier: "vibeTableCell")
        tableView.register(cellXib, forCellReuseIdentifier: "vibeTableCell");
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vibeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var reuseCell = tableView.dequeueReusableCell(withIdentifier: "vibeTableCell") as? VibeTableCell;
//        if(reuseCell == nil){
//            reuseCell =
//        }
        
        if(indexPath.row < vibeList.count){
            let vibe = vibeList[indexPath.row];
            reuseCell?.setupWithVibe(vibeObj: vibe);
//            let cellXib = UINib.init(nibName: "VibeTableCell", bundle: Bundle.main)
//            reuseCell = cellXib.instantiate(withOwner: nil, options: nil);
            
//            reuseCell?.textLabel?.text = vibe.clue;
//            reuseCell?.textLabel?.textColor = UIColor.black;
        }
//        
//        else{
//            reuseCell?.textLabel?.text = "ADD YOUR OWN VIBE"
//            reuseCell?.textLabel?.textColor = UIColor.lightGray;
//        }
//        
        
        //        reuseCell?.detailTextLabel?.text = "\() pieces of art";
        
        return reuseCell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68;
    }
    
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        if(indexPath.row<vibeList.count){
//            print("selected \(vibeList[indexPath.row].clue)");
//            
//            if let vc = storyboard?.instantiateViewController(withIdentifier: "VibeDisplayScreen") as? VibeDisplayViewController{
//                
//                
//                vc.setupWith(vibe: vibeList[indexPath.row])
//                
//                navigationController?.show(vc, sender: nil);
//            }
//        }else{
//            print("Selected Make A new Vibe");
//            
//            if let vc = storyboard?.instantiateViewController(withIdentifier: "VibeWriteScreen") as? VibeWriteViewController{
//                
//                vc.setupWithGalleryName(name: galleryName)
//                
//                navigationController?.pushViewController(vc, animated: true);
//            }
//            
//            
//            
//        }
        
        
        
        
//    }
}
