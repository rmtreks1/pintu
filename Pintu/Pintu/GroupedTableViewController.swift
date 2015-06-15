//
//  GroupedTableViewController.swift
//  MiniatureHappiness
//
//  Created by Roshan Mahanama on 9/06/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import Photos

class GroupedTableViewController: UITableViewController {
    
    var assets = [[PHAsset]]()
    var isSearch: Bool?
    let formatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isSearch != true {
            DataSource.sharedInstance.populatePhotos()
            assets = DataSource.sharedInstance.photosGroupedByDate
            println("there are \(assets.last!.count) assets")
        } else {
            self.navigationItem.rightBarButtonItem = nil
//            self.navigationController?.navigationItem.rightBarButtonItem
        }
        
        
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        

        // refreshes badge count
        var tabArray = self.tabBarController?.tabBar.items as NSArray!
        var tabItem = tabArray.objectAtIndex(0) as! UITabBarItem
        tabItem.badgeValue = String(DataSource.sharedInstance.uncategorizedPhotosCount())

    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.isSearch = false
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        println(DataSource.sharedInstance.photosGroupedByDate.count)
        
        return self.assets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        let dateRangeAssets = self.assets[section]
        
        return dateRangeAssets.count
    }
    
    
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
//        header.contentView.backgroundColor = UIColor(red: 0/255, green: 181/255, blue: 229/255, alpha: 1.0)
//        header.textLabel.textColor = UIColor.whiteColor() //make the text white
        header.textLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 16)
        header.alpha = 0.5 //make the header transparent
    }
    
    
    
    
    
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let dateRangeAssets = self.assets[section]
//        println("section is \(section) and dateRangeAssets count is: \(dateRangeAssets.count)")
        if dateRangeAssets.count > 0 {
            
            let dateForGroup = monthDayYear(dateRangeAssets.first!.creationDate, formatter: self.formatter)
            return dateForGroup
        }
        
        return "Weird empty date range"
    }
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> MomentsTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MomentsTableViewCell

        // Configure the cell...
        // Configure the cell...
        let thumbnail = CGSizeMake(CGFloat(150), CGFloat(150))
        
        
        // getting the asset
        let dateRangeAssets = self.assets[indexPath.section]
        let asset = dateRangeAssets[indexPath.row] as PHAsset
        
        
        // set the asset identifier
        cell.assetIdentifier = asset.localIdentifier
        cell.asset = asset
        
        // get the image
        let manager = PHImageManager.defaultManager()
        
        manager.requestImageForAsset(asset, targetSize: thumbnail, contentMode: PHImageContentMode.AspectFit, options: nil) { (result:UIImage!, info: [NSObject : AnyObject]!) -> Void in
            cell.photoImage.image = result
        }
        

        return cell
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 444
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            // remove the data
            let dateRangeAssets = self.assets[indexPath.section]
            self.assets[indexPath.section].removeAtIndex(indexPath.row)
            
            
            if self.isSearch != true {
                DataSource.sharedInstance.photosGroupedByDate[indexPath.section].removeAtIndex(indexPath.row)
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let archiveAction = UITableViewRowAction(style: .Default, title: "Archive") { (UITableViewRowAction, NSIndexPath) -> Void in
            println("Archive this")
        }
        archiveAction.backgroundColor = UIColor.lightGrayColor()
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { (UITableViewRowAction, NSIndexPath) -> Void in
            println("Delete this shit permanently")
            // remove the data
            let dateRangeAssets = self.assets[indexPath.section]
            self.assets[indexPath.section].removeAtIndex(indexPath.row)
            
            // this doesn't work if it's a Search
            if self.isSearch != true {
                DataSource.sharedInstance.deleteMedia(indexPath.section, row: indexPath.row)
            }
            
            

            
            
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
        
        return [deleteAction, archiveAction]
    }

    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        if segue.identifier == "fullScreen"{
            
            let destinationVC = segue.destinationViewController as! MainPhotoVC
//            let cell = sender as! MomentsTableViewCell
//            let indexPath = self.tableView.indexPathForCell(cell)
            let asset = DataSource.sharedInstance.assetToComment // fix this
            
            destinationVC.asset = asset
            
        }
        
        println("preparing for segue")
        // Pass the selected object to the new view controller.
    }
    

    
    func monthDayYear(date: NSDate , formatter: NSDateFormatter) -> String{
        
        let dateString = formatter.stringFromDate(date)
        
        return dateString
    }

    
    
    
    @IBAction func refreshButtonPressed(sender: UIBarButtonItem) {
        println("refresh button pressed")
        DataSource.sharedInstance.populatePhotos()
        assets = DataSource.sharedInstance.photosGroupedByDate
        println("there are \(assets.last!.count) assets")
        self.tableView.reloadData()
    }
    
    
    

    
}
