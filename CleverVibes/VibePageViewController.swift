//
//  VibePageViewController.swift
//  CleverVibes
//
//  Created by Josh Safran on 4/25/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import UIKit


class VibePageViewController:UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate{
    
    var viewList : [UIViewController] = []
    var vibeList : [VibeObject] = []
    var galleryName = ""

    
    
    func setupWithVibeList(galleryName: String,list:[VibeObject]){
        if list.count == 0{
            self.galleryName = galleryName
            return;
        }
//        vibeList = list;
      let freshVibes = GalleryDataSource.sharedInstance.freshVibesForList(vibeList: list,useFresh: true);
        let staleVibes = GalleryDataSource.sharedInstance.freshVibesForList(vibeList: list, useFresh: false)
        
        var cleverSortedList = freshVibes.sorted(by:{$0.cleverVotes > $1.cleverVotes});
        var freshSortedList = freshVibes.sorted(by:{$0.correctAnswers + $0.incorrectAnswers < $1.correctAnswers + $1.incorrectAnswers});
        
        let largerIndex = (cleverSortedList.count > freshSortedList.count) ? cleverSortedList.count : freshSortedList.count;
        
        if(largerIndex == 0){
            vibeList = staleVibes;
            self.galleryName = galleryName;
            return;
        }
        
        vibeList = [];
        for i in 0...largerIndex - 1{
            if(i<cleverSortedList.count){
                let cleverVibe = cleverSortedList[i];
                if(!vibeList.contains(where: { element in
                    return element.uuid == cleverVibe.uuid;
                })){
                    vibeList.append(cleverVibe);
                }
            }
            
            if(i<freshSortedList.count){
                let freshVibe = freshSortedList[i];
                if(!vibeList.contains(where: { element in
                    return element.uuid == freshVibe.uuid;
                })){
                    vibeList.append(freshVibe);
                }
            }
        }
        vibeList.append(contentsOf: staleVibes);
//        vibeList = list;
        
        self.galleryName = galleryName
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupViews()
        

        setViewControllers([viewList[0]], direction: UIPageViewControllerNavigationDirection.reverse, animated: false, completion: nil);
            
        
        
        self.automaticallyAdjustsScrollViewInsets = false;
        
        dataSource = self
        
        GalleryDataSource.sharedInstance;
        
      let button = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
        self.navigationItem.backBarButtonItem = button
        
    }
    
  @objc func goBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupViews(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        if(vibeList.count <= 0){
            let nibName = "VibeDisplayScreen";
            
            let viewController = storyBoard.instantiateViewController(withIdentifier: nibName) as! VibeDisplayViewController;
            
            viewController.setupWithoutVibe(name: galleryName);
            viewList.append(viewController);
        }else{
            for index in 0...vibeList.count-1{
                //            let i = 2-index;
                let nibName = "VibeDisplayScreen";
                
                let viewController = storyBoard.instantiateViewController(withIdentifier: nibName) as! VibeDisplayViewController;
                
                viewController.setupWith(vibe: vibeList[index]);
                viewList.append(viewController);
                
                viewController.view.layoutIfNeeded();
                
                
            }
        }
        
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        if( viewController == nil){
            return viewList[0];
        }
        let idx = viewList.index(of: viewController)
        assert(idx != NSNotFound);
        
        
        if(idx! <= 0){
            return nil;
        }
        return viewList[idx! - 1];
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        if( viewController == nil){
            return viewList[0];
        }
        let idx = viewList.index(of: viewController)
        assert(idx != NSNotFound);
        
        if(idx! >= viewList.count - 1){
            return nil;
        }
        return viewList[idx! + 1];
    }
    
    
}
