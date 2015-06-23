//
//  ViewController.swift
//  Pintu
//
//  Created by Roshan Mahanama on 9/06/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {


    var player: AVPlayer? {
        didSet {
            if let avpVC = self.childViewControllers.first as? AVPlayerViewController {
                dispatch_async(dispatch_get_main_queue()) {
                    avpVC.player = self.player
                    
                }
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        self.player?.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    
    
    func configureView() {
        if let playerItem = DataSource.sharedInstance.videoAssetForTesting {
//            self.player = AVQueuePlayer(playerItem: playerItem)
            self.player = playerItem
        }
    }

}

