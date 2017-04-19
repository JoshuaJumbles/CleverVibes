//
//  VibeWriteViewController.swift
//  CleverVibes
//
//  Created by Josh Safran on 4/19/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class VibeWriteViewController:UIViewController,UICollectionViewDelegate,UITextFieldDelegate{
    @IBOutlet weak var artImageView: UIImageView!
    
    @IBOutlet weak var vibeTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var artChooseButton: UIButton!
    
    var galleryName = ""
    
    var chosenArtObject:ArtObject?
    
    var artGridVC : ArtCollectionViewController?
    
    override func viewDidLoad() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    
    @IBAction func didTapChooseArtButton(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ArtGridScreen") as? ArtCollectionViewController{
            vc.setupWithGalleryName(galleryName: galleryName)
            
            vc.collectionView?.delegate = self
            artGridVC = vc
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func didTapDoneButton(_ sender: Any) {

        var newVibe = VibeObject()
        newVibe.clue = vibeTextField.text!
        newVibe.answerObjectNumber = chosenArtObject!.objectNumber
        newVibe.galleryName = galleryName
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "UploadVibeScreen") as? UploadVibeViewController{
            vc.navController = navigationController
            
            vc.setupWithVibeObject(obj: newVibe)
            
            navigationController?.present(vc, animated: true, completion:nil );
        }
    }
    
    
    func setupWithGalleryName(name:String){
        galleryName = name
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        chosenArtObject = artGridVC!.artObjectSet[indexPath.row]
        loadImageForArtObject(obj: chosenArtObject!)
        navigationController?.popViewController(animated: true)
        
        
        updateDoneButtonAvailable()
    }
    
    func loadImageForArtObject(obj:ArtObject){
        let url = obj.fullURL
        Alamofire.request(url).responseImage { response in
            if let image = response.result.value {
                
                if(self.artImageView != nil){
                    self.artImageView.image = image;
                }else{
                    print("Missing full reference");
                }
                
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
        updateDoneButtonAvailable()
    }
    
    func updateDoneButtonAvailable(){
        var available = chosenArtObject != nil && vibeTextField.text != nil
        doneButton.isEnabled = available
    }
}
