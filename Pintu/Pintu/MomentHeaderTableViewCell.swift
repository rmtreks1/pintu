//
//  MomentHeaderTableViewCell.swift
//  Pintu
//
//  Created by Roshan Mahanama on 20/06/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit

class MomentHeaderTableViewCell: UITableViewCell {

    @IBOutlet var dayCounterLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
