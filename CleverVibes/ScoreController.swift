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
    
    func addAnsweredVibe(vibeId:String, correct:Bool){
        UserDefaults.standard.setValue(correct, forKey: "answerHistory_\(vibeId)");
        UserDefaults.standard.synchronize()
    }
    
    func getAnsweredVibeWasCorrect(vibeId:String)-> Bool?{
        if let wasCorrect = UserDefaults.standard.value(forKey: "answerHistory_\(vibeId)") as? Bool{
            return wasCorrect;
        }
        return nil;
    }
    
    func addPersonalVibe(vibeId:String){
        var list = getPersonalVibes();
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
    
    
    func setRegisteredVibeValues(vibe: VibeObject){
        var arr = getCurrentRegisteredVibeValue(vibeId: vibe.uuid);
        arr["points"] = vibe.calculateVibeScore();
        arr["correct"] = vibe.correctAnswers;
        arr["incorrect"] = vibe.incorrectAnswers;
        arr["cleverVotes"] = vibe.cleverVotes;
        
        UserDefaults.standard.setValue(arr, forKey: "registeredObj_\(vibe.uuid)");
        UserDefaults.standard.synchronize();
    }
    
    func getCurrentRegisteredVibeValue(vibeId:String) -> [String:Int]{
        if let arr = UserDefaults.standard.value(forKey: "registeredObj_\(vibeId)") as? [String:Int]{
            return arr;
        }
        
        let empty : [String:Int] = ["points":0,"correct":0,"incorrect":0,"cleverVotes":0];
        return empty;
    }
    
}
