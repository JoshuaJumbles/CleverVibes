//
//  VibeWriteArtSelectionViewController.swift
//  CleverVibes
//
//  Created by Josh Safran on 4/26/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import UIKit

class VibeWriteArtSelectionViewController:UIViewController{
    
    
    var dataSource : ArtCollectionDataSource?
    var delegate : UICollectionViewDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        collectionView.dataSource = dataSource;
        collectionView.delegate = delegate;
        
      let nib = UINib(nibName: "ArtGridCell", bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: "artCell")
      let button = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
        self.navigationItem.backBarButtonItem = button
        
    }
    
  @objc func goBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
}
