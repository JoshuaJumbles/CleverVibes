//
//  VibeCashInGridCell.swift
//  CleverVibes
//
//  Created by Josh Safran on 5/2/17.
//  Copyright © 2017 Josh Safran. All rights reserved.
//

import Foundation
import UIKit

class VibeCashInGridCell:UICollectionViewCell{
    
    @IBOutlet weak var clueLabel: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var answerCountsLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var countsLabel: UILabel!
    @IBOutlet weak var bonusPointsLabel: UILabel!
    
    var config :VibePointUpdateObject?
    
    func setupWithConfig(config:VibePointUpdateObject){
        self.config = config
        clueLabel.text = config.clue;
        answerCountsLabel.text = "Total:\(config.incorrectAnswers) Incorrects, \(config.correctAnswers) Corrects";
        
        pointsLabel.text = "+\(config.displayPoints) new pts";
        
        var total = config.cleverPoints()
        total += config.newAnswerPoints()
        bonusPointsLabel.text = "+\(total) pts"
        var str = "New:";
        if(config.numberOfCleverVotes > 0){
            str = "\(str)\(config.numberOfCleverVotes) Clever Votes, "
        }
        str =  "\(str)\(config.numberOfNewAnswers) Attempts"
        countsLabel.text = str
        
        backgroundImage.image = UIImage(named:"vibes-bg_00\(config.randomArtIndex)");
    }
    
    
}
