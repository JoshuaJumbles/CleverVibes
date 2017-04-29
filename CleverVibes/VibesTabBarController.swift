//
//  VibesTabBarController.swift
//  CleverVibes
//
//  Created by Mary Jumbelic on 4/28/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import UIKit

class VibesTabBarController:UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.green;//self.view.tintColor;
        UITabBar.appearance().tintColor = UIColor.init(colorLiteralRed: 120.0/255.0, green: 55.0/255.0, blue: 111.0/255.0, alpha: 1.0)
        //UIApplication.shared.delegate?.window??.tintColor;
//        UITabBar.appearance().barTintColor = view.tintColor;
    }
}
