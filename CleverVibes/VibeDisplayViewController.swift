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
    
    @IBOutlet weak var answerButton: UIButton!
    
    @IBOutlet weak var vibeLabel: UILabel!
    
    @IBOutlet weak var galleryLabel: UILabel!
    
    var galleryName = ""
    
    
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
            answerButton.isHidden = true;
            vibeLabel.text = "No vibe here yet!"
        }else{
            vibeLabel.text = vibe!.clue
            
            var alreadyAnsweredList = ScoreController.shareScoreInstance.getUsedVibes()
            var userCreatedList = ScoreController.shareScoreInstance.getPersonalVibes()
            if(alreadyAnsweredList.contains(vibe!.uuid)){
                
                answerButton.setTitle("I already answered!", for: UIControlState.disabled);
                answerButton.isEnabled = false;
                
            }else if(userCreatedList.contains(vibe!.uuid)){
                answerButton.setTitle("I made this vibe!", for: UIControlState.disabled);
                answerButton.isEnabled = false;
                
            }
            
            
            
            
        }
        
        artGridDataSource.setupWithGalleryName(galleryName: galleryName);
        galleryLabel.text = clipGalleryName(name: galleryName)
    }
    
    
    @IBAction func didTouchAnswerButton(_ sender: Any) {
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
