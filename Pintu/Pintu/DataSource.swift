//
//  DataSource.swift
//  MiniatureHappiness
//
//  Created by Roshan Mahanama on 8/06/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import Photos

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
        
        self.photosGroupedByDate = groupIntoDays(self.photosFetchResult!)

        
    }
 
    
    func groupIntoDays(fetchResult: PHFetchResult) -> [[PHAsset]]{
        
        // clear out existing values
        var assetsGroupedByDate = [[PHAsset]]()
        var currentDateOfFilter = NSDate()
        var currentAssetsGroup = [PHAsset]()
        
        // loop through PHFetchResult to separate into arrays where all dates are the same
//        if let retrievedPhotosFetchResult = photosFetchResult
            for index in 0..<fetchResult.count {
                let value = fetchResult[index] as! PHAsset
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
        
     
        println("number of days: \(assetsGroupedByDate.count)")
        
        return assetsGroupedByDate
        
    }
    
    
    
    func retrievePHAssetsBasedOnIdentifiers(identifiers: [String]) -> [[PHAsset]]{
        
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        let fetchResult = PHAsset.fetchAssetsWithLocalIdentifiers(identifiers, options: fetchOptions) as PHFetchResult
        
        println("fetched \(fetchResult.count) out of \(identifiers.count)")
        
        
        
        // assets grouped into date
        // for timing
        println("starting groupIntoDays \(NSDate())")
        
        // clear out existing values
        var photosGroupedByDate = [[PHAsset]]()
        var currentDateOfFilter = NSDate()
        var currentAssetsGroup = [PHAsset]()
        
        // loop through PHFetchResult to separate into arrays where all dates are the same
        let retrievedPhotosFetchResult = fetchResult
        for index in 0...retrievedPhotosFetchResult.count-1 {
            let value = retrievedPhotosFetchResult[index] as! PHAsset
            if NSDate.areDatesSameDay(currentDateOfFilter, dateTwo: value.creationDate) {
                currentAssetsGroup.append(value)
            } else {
                if currentAssetsGroup.count > 0 {
                    photosGroupedByDate.append(currentAssetsGroup)
                }
                currentAssetsGroup = []
                currentAssetsGroup.append(value)
                currentDateOfFilter = value.creationDate
            }
        }
        
        if currentAssetsGroup.count > 0 {
            photosGroupedByDate.append(currentAssetsGroup)
        }
        
        
        println("number of days: \(photosGroupedByDate.count)")
        
        return photosGroupedByDate
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
    
    
    
    
    // didn't really work
    func populateMoments(){
        self.momentsFetchResult = PHCollectionList.fetchCollectionListsWithType(PHCollectionListType.MomentList, subtype: PHCollectionListSubtype.MomentListYear, options: nil)
        
        println("count of moments: \(self.momentsFetchResult!.count)")
        
    }
    
    
    
    
    
}
