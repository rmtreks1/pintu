//
//  MainPhotoVC.swift
//  Pintu
//
//  Created by Roshan Mahanama on 9/06/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import Photos
import CoreData

class MainPhotoVC: UIViewController {

    @IBOutlet var fullScreenMedia: UIImageView!
    var asset: PHAsset?
    let manager = PHImageManager.defaultManager()
    let imageOptions = PHImageRequestOptions()
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var tapGesturePressed: UITapGestureRecognizer!
    @IBOutlet var commentTextView: UITextView!
    
    // core data
    var comments = [NSManagedObject]()
    
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
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Media")
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            self.comments = results
            println("found \(results.count) saved comments")
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
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
            saveComment(comment)
        }

    }
    
    
    
    
    // MARK: - Core Data
    func saveComment(comment: String) {
        
        println("saving comment")
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity =  NSEntityDescription.entityForName("Media",
            inManagedObjectContext:
            managedContext)
        
        let newMedia = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        //3
        newMedia.setValue(comment, forKey: "comments")
        
        //4
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }  
        //5
        comments.append(newMedia)
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
