//
//  AnswerRevealViewController.swift
//  CleverVibes
//
//  Created by Josh Safran on 4/18/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class AnswerRevealViewController:UIViewController{
    
    @IBOutlet weak var answerImage: UIImageView!
    @IBOutlet weak var answerStatusLabel: UILabel!
    
    @IBOutlet weak var pointsGainedLabel: UILabel!
    @IBOutlet weak var hubReturnButton: UIButton!
    
    @IBOutlet weak var vibeClue: UILabel!
    
    @IBOutlet weak var cleverButton: UIButton!
    @IBOutlet weak var rudeButton: UIButton!
    
    @IBOutlet weak var youAreLabel: UILabel!
    
    var vibe = VibeObject()
    var artChoice = ArtObject()
    
    var navController : UINavigationController?;
    
    var isDisplayingHistoricalAnswer = false;
    var historicalCorrect = false;
    
    func setupWithHistoricalAnswer(vibe obj: VibeObject,wasCorrect:Bool){
        vibe = obj;
        loadArt()
        isDisplayingHistoricalAnswer = true;
        
        historicalCorrect = wasCorrect;
    }
    
    func setupWith(vibe obj:VibeObject, answerChoice:ArtObject){
        vibe = obj;
        artChoice = answerChoice
        
        loadArt()
        isDisplayingHistoricalAnswer = false;
        
    }
    
    func loadArt(){
        if let artObject = GalleryDataSource.sharedInstance.objectForId(objectNum: vibe.answerObjectNumber){
            
            let url = artObject.fullURL;
            Alamofire.request(url).responseImage { response in
                if let image = response.result.value {
                    if(self.answerImage != nil){
                        self.answerImage.image = image;
                    }else{
                        print("Missing thumbnail reference");
                    }
                    
                }
            }
        }else{
            print("Error: no art object for answer number");
        }
    }
    
    override func viewDidLoad() {
        var correct = false;
        if(isDisplayingHistoricalAnswer){
            cleverButton.isEnabled = false;
            rudeButton.isEnabled = false;
            correct = historicalCorrect;
            youAreLabel.text = "You were..."
        }else{
            youAreLabel.text = "You are..."
            correct = (artChoice.objectNumber == vibe.answerObjectNumber);
            ScoreController.shareScoreInstance.addAnsweredVibe(vibeId: vibe.uuid, correct: correct);
            if(correct){
                ScoreController.shareScoreInstance.addPoints(points: 100);
                vibe.correctAnswers += 1;
            }else{
                ScoreController.shareScoreInstance.addUsedVibe(vibeId: vibe.uuid);
                vibe.incorrectAnswers += 1;
            }
        }
        pointsGainedLabel.isHidden = !correct;
        
        answerStatusLabel.text = (correct) ? "CORRECT!" : "INCORRECT";
        answerStatusLabel.textColor = (!correct) ? UIColor.init(colorLiteralRed: 223.0/255.0, green: 76.0/255.0, blue: 154.0/255.0, alpha: 1.0): UIColor.init(colorLiteralRed: 45.0/255.0, green: 144.0/255.0, blue: 87.0/255.0, alpha: 1.0);
        
        vibeClue.text = vibe.clue
    }
    
    @IBAction func didPressDone(_ sender: Any) {
        dismissAndReturnToHub()
    }
    
    @IBAction func didPressRude(_ sender: Any) {
        vibe.lameVotes += 1;
        dismissAndReturnToHub()
    }
    @IBAction func didPressClever(_ sender: Any) {
        vibe.cleverVotes += 1;
        dismissAndReturnToHub()
    }
    
    func dismissAndReturnToHub(){
        if(!isDisplayingHistoricalAnswer){
            VibeUploadController.uploadVibeChanges(vibe: vibe, isPersonalVibe:false);
        }
        
        dismiss(animated: true) {
            self.navController?.popToRootViewController(animated: true);
        }
    }
}
