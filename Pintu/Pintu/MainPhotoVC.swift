//
//  MainPhotoVC.swift
//  Pintu
//
//  Created by Roshan Mahanama on 9/06/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import Photos

class MainPhotoVC: UIViewController {

    @IBOutlet var fullScreenMedia: UIImageView!
    var asset: PHAsset?
    let manager = PHImageManager.defaultManager()
    let imageOptions = PHImageRequestOptions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.HighQualityFormat
        let fullScreen = self.view.frame.size
        

        
        manager.requestImageForAsset(asset, targetSize: fullScreen, contentMode: PHImageContentMode.AspectFit, options: imageOptions) { (result:UIImage!, info: [NSObject : AnyObject]!) -> Void in
            self.fullScreenMedia.image = result
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
