//
//  EventsTableViewController.swift
//  Pintu
//
//  Created by Roshan Mahanama on 19/06/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, QBImagePickerControllerDelegate {
    
    // MARK: - Variables
    // QBImagePicker => https://github.com/questbeat/QBImagePicker
    let imagePicker = QBImagePickerController()
    var pickedImage: UIImage?
    
    // DataSource
//    var moments = [[UIImage]]()
    var moments = [[String: AnyObject]]()
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // setting up the image picker
        imagePicker.delegate = self
        imagePicker.allowsMultipleSelection = true
        imagePicker.showsNumberOfSelectedAssets = true
        imagePicker.prompt = "choose your moments"
        
        
        // time to make some dummy data
        makeSomeDummyData()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

        
        // get the images
        let thisMoment = self.moments[indexPath.row]
        let pageImages = thisMoment["images"] as! [UIImage]
        let comment = thisMoment["comment"] as! String
        let profileImage = thisMoment["profileImage"] as! UIImage
        
        // Configure the cell...
        cell.pageImages = pageImages
        cell.commentLabel.text = comment
        cell.profileImageView.image = profileImage
        let cellWidth = self.tableView.frame.size.width
        cell.setupTheScrollView(cellWidth)
        
        
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
        
    
        
        presentViewController(imagePicker, animated: true, completion: nil)
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
        
        
        
        dismissViewControllerAnimated(true, completion: nil)
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
        
        let dummyMoment: [String: AnyObject] = ["images": dummyMomentImages, "comment": dummyComment, "profileImage": dummyProfileImage!]
        

        
        // dummy moment 2
        let dummyMoment2Images = [UIImage(named: "5.jpg")!,
            UIImage(named: "6.jpg")!,
            UIImage(named: "7.jpg")!]
        
        let dummyComment2 = "can't believe we got to see these animals"
        
        let dummyProfileImage2 = UIImage(named: "bain.jpg")
        
        let dummyMoment2: [String: AnyObject] = ["images": dummyMoment2Images, "comment": dummyComment2, "profileImage": dummyProfileImage2!]
        
        
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
