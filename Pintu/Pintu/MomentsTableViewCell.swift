//
//  MomentsTableViewCell.swift
//  MiniatureHappiness
//
//  Created by Roshan Mahanama on 9/06/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit

class MomentsTableViewCell: UITableViewCell {

    @IBOutlet var photoImage: UIImageView!
    @IBOutlet var commentsButton: UIButton!
    @IBOutlet var peopleButton: UIButton!
    var assetIdentifier: String?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func commentsButtonPressed(sender: AnyObject) {
        println("comment button pressed for \(assetIdentifier!)")
    }
    
    
    @IBAction func peopleButtonPressed(sender: AnyObject) {
        println("people button pressed")
    }
    
    
    
    
    
    

}
