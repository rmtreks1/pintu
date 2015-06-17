//
//  HashtagHelper.swift
//  Pintu
//
//  Created by Roshan Mahanama on 17/06/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import CoreData

class HashtagHelper: NSObject {
    
    static let sharedInstance = HashtagHelper()
    let entityIdentifier = "Hashtags"

    
    
    // check if the hashtag is unique
    func isUnique(hashtag: String) -> Bool {
        
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:self.entityIdentifier)
        let predicate = NSPredicate(format: "hashtag == %@", hashtag)
        fetchRequest.predicate = predicate
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            println("found \(results.count)")
            if results.count == 0 {
                return true
            } else {
                return false
            }
            
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
            return true
        }
    }
    
    
    
    
    func saveHashTags(hashtags: [String]){
    
        for hashtag in hashtags {
            if isUnique(hashtag) {
                println("unique hashtag - save this")
                saveHashtag(hashtag)
            } else {
                println("don't save")
            }
        }
        
        
    }
    
    
    
    private func saveHashtag(hashtag: String){
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity =  NSEntityDescription.entityForName(self.entityIdentifier,
            inManagedObjectContext:
            managedContext)
        
        let newHashtag = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        //3
        newHashtag.setValue(hashtag, forKey: "hashtag")

        
        //4
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        } else {
            println("saved hashtag")
        }
        
        
    }
    
    
   
}
