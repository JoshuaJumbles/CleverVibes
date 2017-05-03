//
//  VibeObject.swift
//  CleverVibes
//
//  Created by Josh Safran on 4/18/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation

class VibeObject{
    
    var clue = "Default Clue Text?!";
    var createdAtDate = Date(timeIntervalSince1970: 0)
    var answerObjectNumber = 0
    var galleryName = ""
    
    var correctAnswers = 0
    var incorrectAnswers = 0
    var lameVotes = 0
    var cleverVotes = 0
    
    var version = 0
    
    let scoreChunkSize = 6;
    
    
    var configDict :[String:Any] = [:]
    var uuid = "";
    
    let scoreSteps = 4;
    let topScore = 300;
    
    let cleverThreshold = 0.5;
    let lameThreshold = 0.5;
    let lameMinimumVotes = 8;
    
    init(){
        
        
    }
    
    init(config:[String:Any], uuid:String, versionNumber:Int){
        configDict = config;
        self.uuid = uuid;
        
        if let str = config["clue"] as? String{
            clue = str
        }
        if let url = config["galleryName"] as? String{
            galleryName = url
        }
        if let num = config["answerObjectNumber"] as? Int{
            answerObjectNumber = num
        }
        if let num = config["correctAnswers"] as? Int{
            correctAnswers = num
        }
        if let num = config["incorrectAnswers"] as? Int{
            incorrectAnswers = num
        }
        if let num = config["lameVotes"] as? Int{
            lameVotes = num
        }
        if let num = config["cleverVotes"] as? Int{
            cleverVotes = num
        }
        
        version = versionNumber;
    }
    
    
    func calculateVibeScore()->Int{
        let totalAnswers = correctAnswers + incorrectAnswers;
        let numberOfPointChunks = Int(totalAnswers / scoreChunkSize);
        if(totalAnswers == 0){
            return 0;
        }
        
        let correctPercentage = Float(correctAnswers) / Float(totalAnswers);
        
        
        let stepAmount = 1.0 / (Float(scoreSteps) * 2.0);
        
        
        var score = topScore;
        for i in 1...scoreSteps-1{
            var percentMin = 0.5-stepAmount * Float(i)
            var percentMax = 0.5+stepAmount * Float(i)
            var isInRange = (correctPercentage > percentMin) &&
                            (correctPercentage<percentMax);
            
            if(isInRange){
                break;
            }
            
            score -= 100;
        }
        
        
        return score * numberOfPointChunks;
        
    }
    
    func totalScoreIncludingBonus()->Int{
        var cleverScore = cleverVotes * 25;
        var totalVotesScore = (incorrectAnswers + correctAnswers) * 10
        return cleverScore + totalVotesScore + calculateVibeScore()
    }
    
    func isVotedClever() -> Bool{
        if(isFresh()){
            return false;
        }
        
        let totalAnswers = correctAnswers + incorrectAnswers;
        
        let cleverPercent = Float(cleverVotes) / Float(totalAnswers);
        return cleverPercent > Float(cleverThreshold);
    }
    
    func isFresh()->Bool{
        let totalAnswers = correctAnswers + incorrectAnswers
        return totalAnswers < scoreChunkSize;
    }
    
    func isVotedRude() -> Bool{
        let totalAnswers = correctAnswers + incorrectAnswers;
        if(totalAnswers<lameMinimumVotes){
            return false;
        }
        let lamePercent = Float(lameVotes) / Float(totalAnswers);
        return lamePercent > Float(lameThreshold);
    }
    
    
}
