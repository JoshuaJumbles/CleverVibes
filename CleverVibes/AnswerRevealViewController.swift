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
    
    @IBOutlet weak var hubReturnButton: UIButton!
    
    @IBOutlet weak var vibeClue: UILabel!
    
    var vibe = VibeObject()
    var artChoice = ArtObject()
    
    var navController : UINavigationController?;
    
    func setupWith(vibe obj:VibeObject, answerChoice:ArtObject){
        vibe = obj;
        artChoice = answerChoice
        
        if let artObject = GalleryDataSource.sharedInstance.objectForId(objectNum: obj.answerObjectNumber){
        
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
        let correct = (artChoice.objectNumber == vibe.answerObjectNumber);
        
        answerStatusLabel.text = (correct) ? "CORRECT!" : "Darn";
        answerStatusLabel.textColor = (correct) ? UIColor.green: UIColor.red;
        
        vibeClue.text = vibe.clue
    }
    
    
    @IBAction func didPressHubReturn(_ sender: Any) {
        
//        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true) { 
            self.navController?.popToRootViewController(animated: true);
        }
    }
}
