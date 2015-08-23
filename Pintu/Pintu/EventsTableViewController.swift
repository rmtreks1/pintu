//
//  EventsTableViewController.swift
//  Pintu
//
//  Created by Roshan Mahanama on 19/06/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class EventsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, QBImagePickerControllerDelegate, PFLogInViewControllerDelegate {
    
    // MARK: - Variables
    // QBImagePicker => https://github.com/questbeat/QBImagePicker
    var imagePicker: QBImagePickerController?
    var pickedImage: UIImage?
    
    // DataSource
//    var moments = [[UIImage]]()
    var moments = [[String: AnyObject]]()
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        

        
        
        // time to make some dummy data
        makeSomeDummyData()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Parse
        
        if ((PFUser.currentUser()) == nil) {
            println("******** no users ---- requesting login ********** ")
            var logInController = PFLogInViewController()
            logInController.delegate = self
            self.presentViewController(logInController, animated:true, completion: nil)
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
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        let numberOfMomentsInDay = self.moments.count
        
        return numberOfMomentsInDay
    }

    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = self.tableView.dequeueReusableCellWithIdentifier("headerCell") as! MomentHeaderTableViewCell

        headerCell.dateLabel.text = "Sat, 20 June 2015"
        headerCell.dayCounterLabel.text = "Day -10"
        
        return headerCell
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> MomentTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("momentsCell", forIndexPath: indexPath) as! MomentTableViewCell

        
        // reset incase cell used before
        cell.resetCell()
        
        
        // setup the cell
        cell.setUpCell()
        
        // check the moment type
        let thisMoment = self.moments[indexPath.row]
        let momentType = thisMoment["momentType"] as! String
        println(momentType)
        
        
        if momentType == "image" {
            // get the images
            
            let pageImages = thisMoment["images"] as! [UIImage]
            let comment = thisMoment["comment"] as! String
            let profileImage = thisMoment["profileImage"] as! UIImage
            
            // Configure the cell...
            cell.pageImages = pageImages
            cell.commentLabel.text = comment
            cell.profileImageView.image = profileImage
            let cellWidth = self.tableView.frame.size.width
            cell.setupTheScrollView(cellWidth)
          
        } else {
            cell.setUpVideoCell(self.tableView.frame.size.width)
        }
        
        
        
        
        /*
        Need to be able to pass through a dictionary to the moment table view cell.
        With the images, videos, comments, likes, etc...
        */
        
        

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
    
    
    
    // MARK: - Camera Picker, UIImagePicker Delegate
    
    @IBAction func createNewMoment(sender: UIBarButtonItem) {
        println("create new moment")
        
        imagePicker = QBImagePickerController()
        
        // setting up the image picker
        imagePicker!.delegate = self
        imagePicker!.allowsMultipleSelection = true
        imagePicker!.showsNumberOfSelectedAssets = true
        imagePicker!.prompt = "choose your moments"
        
        presentViewController(imagePicker!, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        println("finished picking")
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
           self.pickedImage = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // MARK: - QBImagePicker Delegate

    func qb_imagePickerControllerDidCancel(imagePickerController: QBImagePickerController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func qb_imagePickerController(imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        println("user picked \(assets.count) media")
        println("put these assets into a moment")
        
        /* 
        Need to split the videos and images
        */
        var videoAssets = [PHAsset]()
        var imageAssets = [PHAsset]()
        
        
        for asset in assets as! [PHAsset] {
            if asset.mediaType == PHAssetMediaType.Video {
                videoAssets.append(asset)
            } else if asset.mediaType == PHAssetMediaType.Image {
                imageAssets.append(asset)
            }
        }
        
        println("\(imageAssets.count) images and \(videoAssets.count) videos : total \(assets.count)")
        
        
        // set image size
        let width = self.tableView.frame.width
        let imageSize = CGSizeMake(width, width)
        
        // get the image for every asset
        var fetchedImages = [UIImage]()

        
        let manager = PHImageManager.defaultManager()
        
        // Image Assets
        // create 1 moment for all the image assets
        for asset in imageAssets {
            manager.requestImageForAsset(asset, targetSize: imageSize, contentMode: PHImageContentMode.AspectFill, options: nil, resultHandler: { (result: UIImage!, info: [NSObject : AnyObject]!) -> Void in
                
                
                if let highImageQuality = info[PHImageResultIsDegradedKey] as? Bool {
                    if !highImageQuality {
                        println("good quality image retrieved")
                        fetchedImages.append(result)
                    }
                }
                
                if fetchedImages.count == imageAssets.count {
                    
                    // creating new moment out of the images
                    
                    
                    let newComment = "can't believe we got to see these animals"
                    
                    let newProfileImage = UIImage(named: "bain.jpg")
                    
                    let newMoment: [String: AnyObject] = ["momentType": "image", "images": fetchedImages, "comment": newComment, "profileImage": newProfileImage!]
                    
                    
                    //        self.moments.append(newMoment)
                    self.moments.insert(newMoment, atIndex: 0)
                    
                    self.tableView.reloadData()
                }
                
            })
        }
        
       
        
        // Video Assets
//        let player = AVQueuePlayer()
        for asset in videoAssets {
            manager.requestPlayerItemForVideo(asset, options: nil, resultHandler: { (result: AVPlayerItem!, info: [NSObject : AnyObject]!) -> Void in
                // creating new moment out of the images
                
                
                let newComment = "video time"
                
                let newProfileImage = UIImage(named: "bain.jpg")
                
                let newMoment: [String: AnyObject] = ["momentType": "video", "video": result, "comment": newComment, "profileImage": newProfileImage!]
                
                
                
                DataSource.sharedInstance.videoAssetForTesting = AVQueuePlayer(playerItem: result)
                
                
                //        self.moments.append(newMoment)
                self.moments.insert(newMoment, atIndex: 0)
                
                // do something like once count matches then reload Data
                self.tableView.reloadData()
                
                

                

            })
        }
        

        
        
        
        
        
        
        
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Cell Interactions
    
    @IBAction func longPressed(sender: UILongPressGestureRecognizer) {
        println("long pressed like a baby")
//        let cell = MomentTableViewCell.sender.view
        
        let point: CGPoint = sender.locationInView(self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(point)
        
        if let _indexPath = indexPath {
            println("indexPath is \(_indexPath.section):\(_indexPath.row)")
        }
    }
    
    
   
    @IBAction func tapPressed(sender: UITapGestureRecognizer) {
        let point: CGPoint = sender.locationInView(self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(point)
        
        if let _indexPath = indexPath {
            let cell = self.tableView.cellForRowAtIndexPath(_indexPath) as! MomentTableViewCell
            
            // switching volume on and off
            if cell.mediaType == "video" {
                println("this is a video")
                if cell.playerVC.player.volume == Float(0) {
                    cell.playerVC.player.volume = Float(1)
                } else {
                    cell.playerVC.player.volume = Float(0)
                }
            }
        }
    }
    
    
    
    
    
    
    
    // MARK: - Dummy Data
    
    func makeSomeDummyData(){
        
        // dummy moment 1
        let dummyMomentImages = [UIImage(named: "1.jpg")!,
            UIImage(named: "2.jpg")!,
            UIImage(named: "3.jpg")!,
            UIImage(named: "4.jpg")!]
        
        let dummyComment = "amazing landmarks from our travels around the world"

        let dummyProfileImage = UIImage(named: "batman.jpg")
        
        let dummyMoment: [String: AnyObject] = ["momentType": "image", "images": dummyMomentImages, "comment": dummyComment, "profileImage": dummyProfileImage!]
        

        
        // dummy moment 2
        let dummyMoment2Images = [UIImage(named: "5.jpg")!,
            UIImage(named: "6.jpg")!,
            UIImage(named: "7.jpg")!]
        
        let dummyComment2 = "can't believe we got to see these animals"
        
        let dummyProfileImage2 = UIImage(named: "bain.jpg")
        
        let dummyMoment2: [String: AnyObject] = ["momentType": "image", "images": dummyMoment2Images, "comment": dummyComment2, "profileImage": dummyProfileImage2!]
        
        
        for index in 0...4 {
            if index % 2 == 0 {
                self.moments.append(dummyMoment2 as [String : AnyObject])
            } else {
               self.moments.append(dummyMoment as [String : AnyObject])
            }
        }
        println("created \(self.moments.count) dummy moments")
    }
    
    
    

}
