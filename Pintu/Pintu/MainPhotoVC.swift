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
    var media = [NSManagedObject]()
    
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
        
        
        self.commentTextView.becomeFirstResponder()
        
        
        
        
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Media")
        let predicate = NSPredicate(format: "assetIdentifier == %@", self.asset!.localIdentifier)
        fetchRequest.predicate = predicate
        
        
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            self.media = results
            println("found \(results.count) saved comments")
            commentForAsset(self.asset!)
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
    
    
    @IBAction func saveButtonPressed(sender: UIBarButtonItem) {
        self.commentTextView.resignFirstResponder()
        if let comment = self.commentTextView.text {
            println(comment)
            saveComment(comment)
        }
    }
    
    
    // MARK: - Core Data
    func saveComment(comment: String) {
        
        if comment != "" {
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
            newMedia.setValue(self.asset!.localIdentifier, forKey: "assetIdentifier")
            
            //4
            var error: NSError?
            if !managedContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }  
            //5
            self.media.append(newMedia)
        }
        
        
    }

    
    func commentForAsset(asset: PHAsset) {
        for media in self.media {
            let mediaIdentifier = media.valueForKey("assetIdentifier") as! String
            if mediaIdentifier == asset.localIdentifier {
                let comment = media.valueForKey("comments") as! String
                println(comment)
            }
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
