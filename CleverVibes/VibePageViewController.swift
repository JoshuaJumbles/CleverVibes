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
        vibeList = list;
        self.galleryName = galleryName
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
//        self.view.backgroundColor = UIColor.blue;
//        if(vibeList.count <= 0){
//            
//        }else{
        setViewControllers([viewList[0]], direction: UIPageViewControllerNavigationDirection.reverse, animated: false, completion: nil);
            
        
        
        self.automaticallyAdjustsScrollViewInsets = false;
        
        dataSource = self
        
        GalleryDataSource.sharedInstance;
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
