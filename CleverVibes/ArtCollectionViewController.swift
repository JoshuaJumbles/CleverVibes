//
//  ArtCollectionViewController.swift
//  CleverVibes
//
//  Created by Josh Safran on 4/14/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import UIKit

class ArtCollectionViewController:UICollectionViewController{
    
    var artObjectSet : [ArtObject] = []
    
    
    func setupWithGalleryName(galleryName:String){
        artObjectSet = GalleryDataSource.sharedInstance.allObjectsFor(gallery: galleryName);
        
        let cellXib = UINib.init(nibName: "ArtGridCell", bundle: Bundle.main)
        collectionView?.register(cellXib, forCellWithReuseIdentifier: "artCell")
//        collectionView?.register(ArtGridCell.self, forCellWithReuseIdentifier: "artCell")
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artCell", for: indexPath) as? ArtGridCell;
        
        cell!.setupWithImageURL(url: artObjectSet[indexPath.row].thumbnailURL);
        cell!.objectNumberLabel.text = "\(artObjectSet[indexPath.row].objectNumber)";
//        if(cell == nil){
//            let cellXib = UINib.init(nibName: "ArtGridCell", bundle: Bundle.main) as? ArtGridCell
//            cell = cellXib!
//        }
        
//        cell!.contentView.backgroundColor = UIColor.red
        return cell!
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artObjectSet.count;
    }
    
}
