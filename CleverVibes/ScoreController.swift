//
//  ScoreController.swift
//  CleverVibes
//
//  Created by Josh Safran on 4/26/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation

class ScoreController{
    static let shareScoreInstance = ScoreController()
    
    var recentlyEditedIndexPath : IndexPath?
    
    init(){
//        score = getPoints();
    }
    
    func getPoints()->Int{
//        if(UserDefaults.standard.h)
        if let num = UserDefaults.standard.value(forKey: "playerScore") as? Int{
            return num;
        }
        
        return 0;
    }
    
    func addPoints(points:Int){
        var score = getPoints();
        score += points;
        UserDefaults.standard.setValue(score, forKey: "playerScore");
        UserDefaults.standard.synchronize()
        return;
    }
    
    func addUsedVibe(vibeId:String){
        var list = getUsedVibes();
        list.append(vibeId);
        UserDefaults.standard.setValue(list, forKey: "usedVibes");
        UserDefaults.standard.synchronize()
    }
    
    func getUsedVibes() -> [String]{
        if let arr = UserDefaults.standard.value(forKey: "usedVibes") as? [String]{
            return arr;
        }
        
        var empty : [String] = [];
        return empty;
    }
    
    func addPersonalVibe(vibeId:String){
        var list = getUsedVibes();
        list.append(vibeId);
        UserDefaults.standard.setValue(list, forKey: "personalVibes");
        UserDefaults.standard.synchronize()
    }
    
    func getPersonalVibes() -> [String]{
        if let arr = UserDefaults.standard.value(forKey: "personalVibes") as? [String]{
            return arr;
        }
        
        var empty : [String] = [];
        return empty;
    }
    
}
