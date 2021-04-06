//
//  StepByStepCell.swift
//  Flavorful
//
//  Created by Slarve N. on 4/4/21.
//

import UIKit

class StepByStepCell: UITableViewCell {

    @IBOutlet var stepNumberLabel: UILabel!
    @IBOutlet var instructionTextLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
