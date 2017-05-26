//
//  VibeDisplayViewController.swift
//  CleverVibes
//
//  Created by Josh Safran on 4/18/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import UIKit

class VibeDisplayViewController:UIViewController,UICollectionViewDelegate{
    var vibe : VibeObject?
    
    var answerGridViewController: AnswerArtSelectionViewController?
    
    var artGridDataSource = ArtCollectionDataSource();
    
    @IBOutlet weak var cleverView: UIView!
    
    @IBOutlet weak var freshView: UIView!
    
    @IBOutlet weak var answerButton: UIButton!
    
    @IBOutlet weak var vibeLabel: UILabel!
    
    @IBOutlet weak var galleryLabel: UILabel!
    
    @IBOutlet weak var vibeBackgroundImage: UIImageView!
    
    var galleryName = ""
    
    var hasHistoricalAnswer = false
    
    
    func clipGalleryName(name:String)->String{
        var clipString = name;
        if let galleryPrefixRange = clipString.range(of: "Gallery ") {
            clipString.replaceSubrange(galleryPrefixRange, with: "")
        }
        return clipString
    }
    
    func setupWith(vibe vibeObject:VibeObject){
        vibe = vibeObject
        galleryName = vibe!.galleryName
       
        
        
    }
    
    func setupWithoutVibe(name:String){
        galleryName = name
    }
    
    override func viewDidLoad() {
        if(vibe == nil){
            cleverView.isHidden = true;
            freshView.isHidden = true;
            answerButton.isHidden = true;
            vibeLabel.text = "No vibe here yet!"
        }else{
            vibeLabel.text = vibe!.clue
            
            var alreadyAnsweredList = ScoreController.shareScoreInstance.getUsedVibes()
            var userCreatedList = ScoreController.shareScoreInstance.getPersonalVibes()
            if(alreadyAnsweredList.contains(vibe!.uuid)){
                
                answerButton.setTitle("I already answered!", for: UIControlState.disabled);
                
                if let answerHistory = ScoreController.shareScoreInstance.getAnsweredVibeWasCorrect(vibeId: vibe!.uuid){
                    answerButton.setTitle("I already answered!", for: UIControlState.normal);
                    hasHistoricalAnswer = true
                }else{
                    answerButton.isEnabled = false;
                }
                
            }else if(userCreatedList.contains(vibe!.uuid)){
                answerButton.setTitle("I made this vibe!", for: UIControlState.disabled);
                answerButton.isEnabled = false;
                
            }
            
            cleverView.isHidden = !(vibe!.isVotedClever())
            freshView.isHidden = !(vibe!.isFresh())
            
            
            
        }
        let randomNum:UInt32 = arc4random_uniform(9)
        let random = Int(randomNum) + 1
        let imageName = "vibes-bg_00\(random)"
        vibeBackgroundImage.image = UIImage(named: imageName)
        
        artGridDataSource.setupWithGalleryName(galleryName: galleryName);
        galleryLabel.text = clipGalleryName(name: galleryName)
        var button = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: "goBack")
        self.navigationItem.backBarButtonItem = button
        
    }
    
    func goBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTouchAnswerButton(_ sender: Any) {
        if(hasHistoricalAnswer){
            loadHistoricalAnswer()
        }else{
            loadAnswerGrid()
        }
    }
    
    func loadHistoricalAnswer(){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AnswerRevealScreen") as? AnswerRevealViewController{
            let wasCorrect = ScoreController.shareScoreInstance.getAnsweredVibeWasCorrect(vibeId: vibe!.uuid)!;
            vc.setupWithHistoricalAnswer(vibe: vibe!, wasCorrect: wasCorrect);
            vc.navController = navigationController;
            
            navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func loadAnswerGrid(){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "VibeAnswerArtGridScreen") as? AnswerArtSelectionViewController{
            
            answerGridViewController = vc
            vc.clue = vibe?.clue;
            //            vc.clueTitle.text = vibe?.clue
            vc.dataSource = artGridDataSource;
            vc.delegate = self;
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func didTouchWriteButton(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "VibeWriteScreen") as? VibeWriteViewController{
            
            vc.artDataSource = artGridDataSource
            vc.galleryName = galleryName
            
            
            navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chosenArtObject = artGridDataSource.artObjectSet[indexPath.row]
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AnswerRevealScreen") as? AnswerRevealViewController{
            
            vc.setupWith(vibe: vibe!, answerChoice: chosenArtObject)
//            navigationController?.popToRootViewController(animated: false)

            vc.navController = navigationController;
            
            navigationController?.present(vc, animated: true, completion: nil)
        }
        
    }
    
}
