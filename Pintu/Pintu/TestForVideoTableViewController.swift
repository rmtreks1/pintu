//
//  TestForVideoTableViewController.swift
//  Pintu
//
//  Created by Roshan Mahanama on 22/06/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import AVKit

class TestForVideoTableViewController: UITableViewController {
    
    
    var playersDict = [Int:AVQueuePlayer]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        for player in playersDict.values {
            player.pause()
            player.removeAllItems()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        
        
//        let playerItem = DataSource.sharedInstance.videoAssetForTesting
//        
//        if let player = playersDict[indexPath.row]{
//            player.removeAllItems()
//            player.insertItem(playerItem, afterItem: nil)
//        } else {
//            let player = AVQueuePlayer(playerItem: playerItem)
//            let playerVC = AVPlayerViewController()
//            playerVC.view.tag = 100
//            playerVC.player = player
//            playerVC.showsPlaybackControls = false
//            let width = self.tableView.frame.size.width
//            playerVC.view.frame = CGRectMake(0, 0, width, width)
//            cell.contentView.addSubview(playerVC.view)
//            playersDict[indexPath.row] = player
//            playerVC.player.play()
//
//        }
        

        let playerVC = AVPlayerViewController()
        playerVC.player = DataSource.sharedInstance.videoAssetForTesting
        playerVC.showsPlaybackControls = false
        let width = self.tableView.frame.size.width
        playerVC.view.frame = CGRectMake(0, 0, width, width)
        cell.contentView.addSubview(playerVC.view)
        playerVC.player.play()

        
        println("playing")
        
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}