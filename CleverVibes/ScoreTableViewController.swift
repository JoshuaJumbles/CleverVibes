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
    var displayList : [VibeObject] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        vibeList = GalleryDataSource.sharedInstance.loadedVibes;
        
        let cellXib = UINib.init(nibName: "VibeTableCell", bundle: Bundle.main)
//        tableView?.register(cellXib, forCellWithReuseIdentifier: "vibeTableCell")
        tableView.register(cellXib, forCellReuseIdentifier: "vibeTableCell");
        
        filterAndSortDisplayList()
        GalleryDataSource.sharedInstance.highScoreRefreshDelegate = self;
//        UITabBar.appearance().barTintColor = view.tintColor;
//        tabBarItem.
    }
    
    @IBAction func didChangeSegmentedControl(_ sender: Any) {
        filterAndSortDisplayList()
    }
    
    func filterAndSortDisplayList(){
        var usePersonalFilter = filterSegmentedControl.selectedSegmentIndex == 1;
        displayList = [];
        if(usePersonalFilter){
            var personalIds = ScoreController.shareScoreInstance.getPersonalVibes()
            for vibe in vibeList{
                var foundId = false;
                for personalId in personalIds{
                    if(vibe.uuid == personalId){
                        foundId = true;
                        break;
                    }
                }
                if(foundId){
                    displayList.append(vibe)
                }
            }
        }else{
            displayList = vibeList;
        }
        
        displayList.sort { $0.calculateVibeScore() > $1.calculateVibeScore() }
        tableView.reloadData()
    }
    
    func dataSourceDidReload(){
        filterAndSortDisplayList();
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var reuseCell = tableView.dequeueReusableCell(withIdentifier: "vibeTableCell") as? VibeTableCell;

        if(indexPath.row < displayList.count){
            let vibe = displayList[indexPath.row];
            reuseCell?.setupWithVibe(vibeObj: vibe);
        }
        
        return reuseCell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 93;
    }
}
