//
//  VibeTableCell.swift
//  CleverVibes
//
//  Created by Josh Safran on 4/25/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import UIKit

class VibeTableCell : UITableViewCell{
    
    @IBOutlet weak var vibeTextLabel: UILabel!
    @IBOutlet weak var freshImageView: UIImageView!
    @IBOutlet weak var cleverImageView: UIImageView!
    @IBOutlet weak var pointsLabel: UILabel!
    
    func setupWithVibe(vibeObj:VibeObject){
        vibeTextLabel.text = vibeObj.clue;
//        freshIm
        var isFresh = true;
        var isClever = true;
        
        pointsLabel.text = "\(400)";
    }
}
