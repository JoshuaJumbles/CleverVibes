//
//  GalleryCollectionViewController.swift
//  CleverVibes
//
//  Created by Josh Safran on 4/25/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import UIKit

class GalleryCollectionViewController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var galleryGrid: UICollectionView!
    
    @IBOutlet weak var dividerImage: UIImageView!
    
    var galleryNames : [String] = [];
    
    var nearbyGalleryNames : [String] = [];
    var farGalleryNames : [String] = [];
    

    
    
    var sampleNearby = 2;
    
    
    
    var galleryCounts : [String:Int] = [:]
    var galleryFreshVibes : [String:[String]] = [:]
   
    
    func reloadData(){
        setupData()
        galleryGrid.reloadData()
//        galleryGrid.rel
        
    }
    
    func setupData(){
        galleryCounts = GalleryDataSource.sharedInstance.galleryArtCounts();
        galleryFreshVibes = GalleryDataSource.sharedInstance.galleryFreshVibes();
        galleryNames = Array(galleryCounts.keys);
        galleryNames.sort() //{ $0.Name < $1.Name }
        
        nearbyGalleryNames = [];
        for i in 0 ... sampleNearby-1{
            nearbyGalleryNames.append( galleryNames[i]);
        }
        
        farGalleryNames = [];
        
        for i in sampleNearby ... galleryNames.count-1{
            farGalleryNames.append( galleryNames[i]);
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        
        let cellXib = UINib.init(nibName: "GalleryGridCell", bundle: Bundle.main)
        galleryGrid?.register(cellXib, forCellWithReuseIdentifier: "galleryGridCell")
        
        GalleryDataSource.sharedInstance.collectionRefreshDelegate = self;
        
//        for fontFamily in UIFont.familyNames{
//            for name in UIFont.fontNames(forFamilyName: fontFamily){
//                print("family:\(fontFamily) font:\(name)")
//            }
//        }
        
        if let font = UIFont(name: "BodoniSvtyTwoOSITCTT-Bold", size: 26){
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font]
        }
        
        
        var button = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: "goBack")
        self.navigationItem.backBarButtonItem = button
        
    }
    
    func goBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pointsLabel.text = "\(ScoreController.shareScoreInstance.getPoints())"
//        reloadData()\
        
//        self.navigationController.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Bodoni Std Bold", size: 20)!]
        
//        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:"Bodoni Std Bold"]; //[NSFontAttributeName: UIFont(name: "Bodoni Std Bold", size: 21)!]
//            [NSForegroundColorAttributeName: UIColor.redColor(),
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        var refreshIndex = ScoreController.shareScoreInstance.recentlyEditedIndexPath;
        
        if( refreshIndex != nil){
            setupData()
            galleryGrid.reloadItems(at: [refreshIndex!]);
            ScoreController.shareScoreInstance.recentlyEditedIndexPath = nil;
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: "gridSectionHeader",
                                                                       for: indexPath) as! GallerySeparatorView;
            view.titleLabel.text = (indexPath.section == 0) ? "NEARBY GALLERIES" : "ALL GALLERIES"
            
            
            return view
        default:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "gridSectionFooter", for: indexPath)
            return view
        }
        
        
    }
    
//    supplem
    @IBAction func didTapRefresh(_ sender: Any) {
        GalleryDataSource.sharedInstance.loadAllVibes()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(section == 0){
            return nearbyGalleryNames.count;
        }else{
            return farGalleryNames.count;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryGridCell", for: indexPath) as? GalleryGridCell;
        
        var name = "";
        switch (indexPath.section){
        case 0:
            name = nearbyGalleryNames[indexPath.row]
            break;
        case 1:
            name = farGalleryNames[indexPath.row];
            break;
        default:
            name = ""
            break;
        }
        
        var unsolvedSet = galleryFreshVibes[name];
        var unsolvedCount = 0;
        if(unsolvedSet != nil){
            unsolvedCount = unsolvedSet!.count;
        }
        cell!.setupWithGallery(galleryName: name, description: "", unsolvedVibeNumber: unsolvedCount)
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ScoreController.shareScoreInstance.recentlyEditedIndexPath = indexPath;
        switch (indexPath.section){
            case 0:
                let galleryName = nearbyGalleryNames[indexPath.row];
                let vc = storyboard?.instantiateViewController(withIdentifier: "VibePageScene") as! VibePageViewController;
                
                vc.setupWithVibeList(galleryName:galleryName, list: GalleryDataSource.sharedInstance.allVibesFor(gallery: galleryName));
                
                vc.hidesBottomBarWhenPushed = true;
                navigationController?.pushViewController(vc, animated: true)
            
            
            case 1:
                let galleryName = farGalleryNames[indexPath.row];
                let vc = storyboard?.instantiateViewController(withIdentifier: "VibePageScene") as! VibePageViewController;
                vc.setupWithVibeList(galleryName:galleryName, list: GalleryDataSource.sharedInstance.allVibesFor(gallery: galleryName));
                vc.hidesBottomBarWhenPushed = true;
                navigationController?.pushViewController(vc, animated: true);
            
            
            default:
                break
        }
    }
}
