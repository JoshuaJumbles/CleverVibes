//
//  AnswerArtSelectionViewController.swift
//  CleverVibes
//
//  Created by Josh Safran on 4/26/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import UIKit

class AnswerArtSelectionViewController:UIViewController{
    
    var dataSource : ArtCollectionDataSource?
    var delegate : VibeDisplayViewController?
    
    @IBOutlet weak var clueTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var clue :String?;
    
    override func viewDidLoad() {
        collectionView.dataSource = dataSource;
        collectionView.delegate = delegate;
        if(clue != nil){
            clueTitle.text = clue!;
        }
        
      let nib = UINib(nibName: "ArtGridCell", bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: "artCell")
    }
}
