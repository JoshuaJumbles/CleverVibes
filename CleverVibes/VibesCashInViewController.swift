//
//  VibesCashInViewController.swift
//  CleverVibes
//
//  Created by Josh Safran on 5/1/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import UIKit

class VibePointUpdateObject{
    var clue = ""
    var correctAnswers = 0
    var incorrectAnswers = 0
    var displayPoints = 0
    var numberOfCleverVotes = 0
    var numberOfNewAnswers = 0
    var randomArtIndex = 1
    
    init(){
        
    }
    
    func cleverPoints()-> Int{
        return numberOfCleverVotes * 25
    }
    
    func newAnswerPoints()-> Int{

        return numberOfNewAnswers * 10
      
    }
    
    func vibeAnswerPoints() -> Int{
        
        return displayPoints
        
    }
    
    func totalPointsDisplayed() -> Int{
        return vibeAnswerPoints() + newAnswerPoints() + cleverPoints()
    }
}

class VibeGeneralActivityUpdateObject{
    var clue = ""
    var numberOfCleverVotes = 0
    var numberOfNewAnswers = 0
    
    init(){
        
    }
}




class VibesCashInViewController:UIViewController, UICollectionViewDataSource{
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    var vibePointUpdates: [VibePointUpdateObject] = []
    var vibeGeneralUpdates: [VibeGeneralActivityUpdateObject]  = []
    var totalCashInPoints = 0
    
    
    override func viewDidLoad() {
        var xib = UINib(nibName: "VibeCashInGridCell", bundle: nil)
        collectionView.register(xib, forCellWithReuseIdentifier: "VibeCashInGridCell");
        
        
        for object in vibePointUpdates{
            totalCashInPoints += object.totalPointsDisplayed();
        }
        ScoreController.shareScoreInstance.addPoints(points: totalCashInPoints);
        pointsLabel.text = "\(totalCashInPoints)"
    }
    
    func setupWithOutOfSyncVibes(objects:[VibeObject]){
        var totalDisplayPoints = 0
        for object in objects{
            var registeredValues = ScoreController.shareScoreInstance.getCurrentRegisteredVibeValue(vibeId: object.uuid)
            
            let currentPoints = object.calculateVibeScore();
            let registeredPoints = registeredValues["points"]!;
            let newPoints = currentPoints - registeredPoints;
//
            let newCleverVotes = object.cleverVotes - registeredValues["cleverVotes"]!;
            
            let registeredTotal = registeredValues["correct"]! + registeredValues["incorrect"]!;
            let totalAnswers = object.correctAnswers + object.incorrectAnswers;
            let newVotesTotal = totalAnswers - registeredTotal;
//
//
            
            
            var vibePointObj = VibePointUpdateObject();
            vibePointObj.clue = object.clue;
            vibePointObj.correctAnswers = object.correctAnswers;
            vibePointObj.incorrectAnswers = object.incorrectAnswers;
            vibePointObj.displayPoints = newPoints;
           
            vibePointObj.numberOfCleverVotes = newCleverVotes;
            vibePointObj.numberOfNewAnswers = newVotesTotal;
            
            let randomNum:UInt32 = arc4random_uniform(9)
            let random = Int(randomNum) + 1
            vibePointObj.randomArtIndex = random
            
            if(vibePointObj.displayPoints <= 0){
                vibePointObj.displayPoints = 0;
            }
            
            ScoreController.shareScoreInstance.setRegisteredVibeValues(vibe: object);
            
            vibePointUpdates.append(vibePointObj)
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return vibePointUpdates.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VibeCashInGridCell", for: indexPath) as! VibeCashInGridCell
        cell.setupWithConfig(config: vibePointUpdates[indexPath.row]);
        return cell;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var count = 0;
        if(vibePointUpdates.count > 0){
            count += 1;
        }
        if(vibeGeneralUpdates.count > 0){
            count += 1;
        }
        
        return count;
    }
    
    func commitPoints(){
        
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        dismiss(animated: true, completion: nil);
    }
    @IBAction func didTapHelp(_ sender: Any) {
        
        var vc = storyboard?.instantiateViewController(withIdentifier: "HelpScreen")
        present(vc!, animated: true, completion: nil)
    }
    
}
