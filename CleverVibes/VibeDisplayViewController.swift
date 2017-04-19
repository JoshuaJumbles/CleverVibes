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
    var vibe = VibeObject()
    
    var answerGridViewController: ArtCollectionViewController?
    
    
    
    @IBOutlet weak var vibeLabel: UILabel!
    func setupWith(vibe vibeObject:VibeObject){
        vibe = vibeObject
    }
    
    override func viewDidLoad() {
        vibeLabel.text = vibe.clue
    }
    
    @IBAction func didTouchAnswerButton(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ArtGridScreen") as? ArtCollectionViewController{
            
            answerGridViewController = vc
            
            vc.setupWithGalleryName(galleryName: vibe.galleryName)
            vc.collectionView?.delegate = self;
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chosenArtObject = answerGridViewController?.artObjectSet[indexPath.row]
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AnswerRevealScreen") as? AnswerRevealViewController{
//            navigationController.present
        
            
            vc.setupWith(vibe: vibe, answerChoice: chosenArtObject!)
//            navigationController?.popToRootViewController(animated: false)
            
//            navigationController?.setViewControllers(vcList, animated: true)
            vc.navController = navigationController;
            
            navigationController?.present(vc, animated: true, completion: nil)
        }
        
    }
    
}
