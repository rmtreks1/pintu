//
//  MainPhotoVC.swift
//  Pintu
//
//  Created by Roshan Mahanama on 9/06/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import Photos
import CoreLocation

class MainPhotoVC: UIViewController {

    @IBOutlet var fullScreenMedia: UIImageView!
    var asset: PHAsset?
    let manager = PHImageManager.defaultManager()
    let imageOptions = PHImageRequestOptions()
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var tapGesturePressed: UITapGestureRecognizer!
    @IBOutlet var commentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // set the location
        
        
        
        
        // set the image
        imageOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.HighQualityFormat
        let thumbnail = self.fullScreenMedia.frame.size
        
        manager.requestImageForAsset(asset, targetSize: thumbnail, contentMode: PHImageContentMode.AspectFit, options: imageOptions) { (result:UIImage!, info: [NSObject : AnyObject]!) -> Void in
            self.fullScreenMedia.image = result
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func tapGesturePressed(sender: UITapGestureRecognizer) {
        println("tapped")
        self.commentTextView.resignFirstResponder()
        if let comment = self.commentTextView.text {
            println(comment)
        }

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
