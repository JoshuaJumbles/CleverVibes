//
//  VibeCashInParticipationGridCell.swift
//  CleverVibes
//
//  Created by Josh Safran on 5/2/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import UIKit

class VibeCashInParticipationGridCell:UICollectionViewCell{
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var clueLabel: UILabel!
    @IBOutlet weak var countsLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    
    func setupWith(config: VibeGeneralActivityUpdateObject){
        clueLabel.text = config.clue
        
        var total = config.numberOfNewAnswers * 10
        total += config.numberOfCleverVotes * 25
    
        var str = "\(config.numberOfCleverVotes) New Clever Votes, \(config.numberOfNewAnswers) New Attempts"
        countsLabel.text = str
    }
}
