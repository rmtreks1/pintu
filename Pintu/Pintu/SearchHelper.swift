//
//  SearchHelper.swift
//  Pintu
//
//  Created by Roshan Mahanama on 11/06/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import Foundation
import Photos

class SearchHelper: NSObject {
    
    static let sharedInstance = SearchHelper()
    
    
    
    
    // MARK: - Retrieve PHAssets
    
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
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}