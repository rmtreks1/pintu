//
//  DataSource.swift
//  MiniatureHappiness
//
//  Created by Roshan Mahanama on 8/06/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import Photos
import CoreData

class DataSource: NSObject {
   
    static let sharedInstance = DataSource()
    var photosFetchResult: PHFetchResult?
    var videosFetchResult: PHFetchResult?
    var photosGroupedByDate = [[PHAsset]]()
    var momentsFetchResult: PHFetchResult?
    var photosPermission: Bool?


    func populatePhotos(){
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        self.photosFetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
        self.videosFetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Video, options: fetchOptions)

        println("photos: \(photosFetchResult!.count) and videos: \(videosFetchResult!.count)")
        
        let categorizedAssets = categorizedAssetList()
        self.photosGroupedByDate = SearchHelper.sharedInstance.groupIntoDaysOnlyUncategorized(self.photosFetchResult!, categorizedAssets: categorizedAssets)
        
        println("there are \(photosGroupedByDate.count) dates")
        

        
        

        
    }
 
    
    func groupIntoDays(fetchResult: PHFetchResult) -> [[PHAsset]]{
        
        // clear out existing values
        var assetsGroupedByDate = [[PHAsset]]()
        var currentDateOfFilter = NSDate()
        var currentAssetsGroup = [PHAsset]()
        
        let categorizedAssets = categorizedAssetList()
        
        // loop through PHFetchResult to separate into arrays where all dates are the same
//        if let retrievedPhotosFetchResult = photosFetchResult
        for index in 0..<fetchResult.count {
            let value = fetchResult[index] as! PHAsset
            
            if !contains(categorizedAssets, value.localIdentifier){
                if NSDate.areDatesSameDay(currentDateOfFilter, dateTwo: value.creationDate) {
                    currentAssetsGroup.append(value)
                } else {
                    if currentAssetsGroup.count > 0 {
                        assetsGroupedByDate.append(currentAssetsGroup)
                    }
                    currentAssetsGroup = []
                    currentAssetsGroup.append(value)
                    currentDateOfFilter = value.creationDate
                }
            }
            
            if currentAssetsGroup.count > 0 {
                assetsGroupedByDate.append(currentAssetsGroup)
            }
        }
        
        println("number of days: \(assetsGroupedByDate.count)")
        
        return assetsGroupedByDate
        
    }
    
    
    
    
    
    
    
    func deleteMedia(section: Int, row: Int){
        let asset = self.photosGroupedByDate[section][row]
//        PHAssetChangeRequest.deleteAssets([asset])
        self.photosGroupedByDate[section].removeAtIndex(row)
        
        
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            //Delete Photo
            PHAssetChangeRequest.deleteAssets([asset])
            },
            completionHandler: {(success, error)in
                if(success){
                    
                    // Move to the main thread to execute
                    dispatch_async(dispatch_get_main_queue(), {
                        println("Trashed")
                    })
                    
                }else{
                    println("Error: \(error)")
                }
        })
        
        
    }
    
    
    func assetAtIndexPath(section: Int, row: Int) -> PHAsset{
        return self.photosGroupedByDate[section][row]
    }
    
    
    
    
    
    // Mark: - Core Data
    func categorizedAssetList() -> [String] {
        
        println("***** categorized asset list *****")
        
        var categorizedAssets = [String]()
        
        
        
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Media")

        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.returnsDistinctResults = true
        fetchRequest.propertiesToFetch = NSArray(object: "assetIdentifier") as [AnyObject]
        
        
        //3
        var error: NSError?
        
        
        let uniqueFetchedResultsDictionary = managedContext.executeFetchRequest(fetchRequest, error: nil)
        println("fetched \(uniqueFetchedResultsDictionary!.count) results")
        
        println(uniqueFetchedResultsDictionary!.first)
        
        if let results = uniqueFetchedResultsDictionary{
            var resultsArray: [String] = []
            for var i = 0; i < results.count; i++ {
                if let result = (results[i] as? [String : String]){
                    if let asset = result["assetIdentifier"]{
                        println(asset)
                        categorizedAssets.append(asset)
                    }
                }
            }
        }
        
        return categorizedAssets
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    // didn't really work
    func populateMoments(){
        self.momentsFetchResult = PHCollectionList.fetchCollectionListsWithType(PHCollectionListType.MomentList, subtype: PHCollectionListSubtype.MomentListYear, options: nil)
        
        println("count of moments: \(self.momentsFetchResult!.count)")
        
    }
    
    
    
    
    
}
