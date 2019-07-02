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
  
  
  
  
  var galleryCounts : [String:Int] = [:]
  var galleryFreshVibes : [String:[String]] = [:]
  
  var asyncVibeObjects: [VibeObject]?
  
  func reloadData(){
    setupData()
    galleryGrid.reloadData()
    let numbers = BeaconController.sharedInstance.nearbyGalleryNumbers;
    setupGalleriesForNearby(numbers: numbers)
    //        galleryGrid.rel
    
  }
  
  func setupData(){
    galleryCounts = GalleryDataSource.sharedInstance.galleryArtCounts();
    galleryFreshVibes = GalleryDataSource.sharedInstance.galleryFreshVibes();
    galleryNames = Array(galleryCounts.keys);
    galleryNames.sort() //{ $0.Name < $1.Name }
    
    setupGalleriesForNearby(numbers: BeaconController.sharedInstance.nearbyGalleryNumbers)
    
    asyncVibeObjects = GalleryDataSource.sharedInstance.outOfSyncVibes();
    if(asyncVibeObjects!.count > 0){
      askDisplayPointCashIn()
    }
    
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupData()
    
    let cellXib = UINib.init(nibName: "GalleryGridCell", bundle: Bundle.main)
    galleryGrid?.register(cellXib, forCellWithReuseIdentifier: "galleryGridCell")
    
    GalleryDataSource.sharedInstance.collectionRefreshDelegate = self;
    BeaconController.sharedInstance.galleryViewController = self;
    //        for fontFamily in UIFont.familyNames{
    //            for name in UIFont.fontNames(forFamilyName: fontFamily){
    //                print("family:\(fontFamily) font:\(name)")
    //            }
    //        }
    
    if let font = UIFont(name: "BodoniSvtyTwoOSITCTT-Bold", size: 26){
      self.navigationController?.navigationBar.titleTextAttributes = [kCTFontAttributeName: font] as [NSAttributedStringKey : Any]
    }
    
    
    let button = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
    self.navigationItem.backBarButtonItem = button
    
    self.navigationController?.view.backgroundColor = UIColor.white
  }
  
  func nearbyGalleriesDidChange(){
    let numbers = BeaconController.sharedInstance.nearbyGalleryNumbers;
    setupGalleriesForNearby(numbers: numbers)
  }
  
  func setupGalleriesForNearby(numbers:[Int]){
    nearbyGalleryNames = []
    farGalleryNames = []
    for name in galleryNames{
      var foundMatch = false
      for num in numbers{
        if(name.contains("\(num)")){
          nearbyGalleryNames.append(name);
          foundMatch = true
          break;
        }
      }
      if(!foundMatch){
        farGalleryNames.append(name)
      }
    }
    farGalleryNames.sort()
    
    galleryGrid.reloadData()
    
  }
  
  func askDisplayPointCashIn(){
    let alertView = UIAlertController(title: "Your vibes scored!", message: "Would you like to review the results?", preferredStyle: UIAlertControllerStyle.alert);
    let laterAction = UIAlertAction(title: "Later", style: UIAlertActionStyle.cancel, handler: nil);
    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { alert in
      self.displayPointCashIn();
    }
    alertView.addAction(laterAction);
    alertView.addAction(okAction);
    
    self.present(alertView, animated: true, completion: nil)
  }
  
  func displayPointCashIn(){
    let vc = storyboard?.instantiateViewController(withIdentifier: "VibesCashInScreen") as! VibesCashInViewController;
    
    vc.setupWithOutOfSyncVibes(objects: asyncVibeObjects!)
    present(vc, animated: true, completion: nil);
  }
  
  @objc func goBack()
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
    let refreshIndex = ScoreController.shareScoreInstance.recentlyEditedIndexPath;
    
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
    return (nearbyGalleryNames.count > 0) ? 2 : 1;
  }
  
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    switch kind {
    case UICollectionElementKindSectionHeader:
      let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                 withReuseIdentifier: "gridSectionHeader",
                                                                 for: indexPath) as! GallerySeparatorView;
      if(nearbyGalleryNames.count <= 0){
        view.titleLabel.text = "ALL GALLERIES"
      }else{
        view.titleLabel.text = (indexPath.section == 0) ? "NEARBY GALLERIES" : "ALL GALLERIES"
        
      }
      
      
      return view
    default:
      let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "gridSectionFooter", for: indexPath)
      return view
    }
    
    
  }
  
  @IBAction func didTapHelp(_ sender: Any) {
    let vc = storyboard?.instantiateViewController(withIdentifier: "HelpScreen")
    present(vc!, animated: true, completion: nil)
  }
  
  //    supplem
  @IBAction func didTapRefresh(_ sender: Any) {
    GalleryDataSource.sharedInstance.loadAllVibes()
  }
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if(nearbyGalleryNames.count <= 0){
      return farGalleryNames.count;
    }else{
      if(section == 0){
        return nearbyGalleryNames.count;
      }else{
        return farGalleryNames.count;
      }
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryGridCell", for: indexPath) as? GalleryGridCell;
    
    var name = "";
    if(nearbyGalleryNames.count <= 0){
      name = farGalleryNames[indexPath.row];
    }else{
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
    var galleryName = "";
    if(nearbyGalleryNames.count <= 0){
      galleryName = farGalleryNames[indexPath.row];
    }else{
      switch (indexPath.section){
      case 0:
        galleryName = nearbyGalleryNames[indexPath.row];
      case 1:
        galleryName = farGalleryNames[indexPath.row];
      default:
        break
      }
    }
    
    pushVibePageScreen(galleryName: galleryName);
  }
  
  func pushVibePageScreen(galleryName:String){
    let vc = storyboard?.instantiateViewController(withIdentifier: "VibePageScene") as! VibePageViewController;
    vc.setupWithVibeList(galleryName:galleryName, list: GalleryDataSource.sharedInstance.allVibesFor(gallery: galleryName));
    vc.hidesBottomBarWhenPushed = true;
    navigationController?.pushViewController(vc, animated: true);
    
  }
}

