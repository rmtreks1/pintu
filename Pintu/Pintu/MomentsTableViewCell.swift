//
//  MomentsTableViewCell.swift
//  MiniatureHappiness
//
//  Created by Roshan Mahanama on 9/06/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import Photos

class MomentsTableViewCell: UITableViewCell {

    @IBOutlet var photoImage: UIImageView!
    @IBOutlet var commentsButton: UIButton!
    @IBOutlet var peopleButton: UIButton!
    var assetIdentifier: String?
    var asset: PHAsset?

    
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
        DataSource.sharedInstance.assetToComment = asset!
    }
    
    
    @IBAction func peopleButtonPressed(sender: AnyObject) {
        println("people button pressed")
    }
    
    
    
    
    
    

}
