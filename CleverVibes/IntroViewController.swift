//
//  IntroViewController.swift
//  SubtleVibes
//
//  Created by Josh Safran on 4/11/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import UIKit

class IntroViewController: UIPageViewController, UIPageViewControllerDataSource {
//    
    
    var viewList : [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        self.view.backgroundColor = UIColor.blue;
        
        setViewControllers([viewList[0]], direction: UIPageViewControllerNavigationDirection.reverse, animated: false, completion: nil);
        
        
        dataSource = self
        
        GalleryDataSource.sharedInstance;
//        GalleryDataSource.sharedInstance.startDownloadingAllObjects()
//        GalleryDataSource.sharedInstance.startSyncingDatabaseToLocalJSON();
//        print(GalleryDataSource.sharedInstance.allGalleryNames())
    }
    
    func setupViews(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        for index in 0...2{
//            let i = 2-index;
            let nibName = "introScreen\(index)";
            
            let viewController = storyBoard.instantiateViewController(withIdentifier: nibName);
            viewList.append(viewController);
            
        }
        
//        self.
        
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
    
    
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"myViewController"];
//    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    [self presentViewController:vc animated:YES completion:NULL];
    
}
