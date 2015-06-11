//
//  SearchViewController.swift
//  Pintu
//
//  Created by Roshan Mahanama on 11/06/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import CoreData
import Photos

class SearchViewController: UITableViewController {

    @IBOutlet var searchBar: UISearchBar!
    var uniqueSearchResults = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.uniqueSearchResults.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        let comment = self.uniqueSearchResults[indexPath.row] as String
        
        // Configure the cell...
        cell.textLabel?.text = comment
        

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SearchSegue" {
            let destinationVC = segue.destinationViewController as! GroupedTableViewController
            
            // let vc know that triggered by search
            destinationVC.isSearch = true
            
            
            // get search text
            let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()
            let searchText = self.uniqueSearchResults[indexPath!.row]
            
  
            // get list of asset local identifiers for the search term
            //1
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            
            //2
            let fetchRequest = NSFetchRequest(entityName:"Media")
            
            let predicate = NSPredicate(format: "comments ==%@", searchText)
            fetchRequest.predicate = predicate
            fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.returnsDistinctResults = true
            fetchRequest.propertiesToFetch = NSArray(object: "assetIdentifier") as [AnyObject]
            
            
            //3
            var error: NSError?
            
            var uniqueAssetsIdentifier = [String]()
//            var searchAssets = [PHAsset]()
            
            let uniqueFetchedResultsDictionary = managedContext.executeFetchRequest(fetchRequest, error: nil)
            println("fetched \(uniqueFetchedResultsDictionary!.count) results")
            
            println(uniqueFetchedResultsDictionary!.first)
            
            if let results = uniqueFetchedResultsDictionary{
                var resultsArray: [String] = []
                for var i = 0; i < results.count; i++ {
                    if let result = (results[i] as? [String : String]){
                        if let asset = result["assetIdentifier"]{
                            println(asset)
                            uniqueAssetsIdentifier.append(asset)
                        }
                    }
                }
                println("\(uniqueAssetsIdentifier.count) unique search results")
            }

            
            
            
            // 4 Fetch the PHAssets
            let searchAssets = getPHAssets(uniqueAssetsIdentifier)
            
            
            //5. Set the Assets
            destinationVC.assets = searchAssets
            
        }
    }
    
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    if segue.identifier == "SearchSegue"{
    
    let destinationVC = segue.destinationViewController as! MainPhotoVC
    let cell = sender as! MomentsTableViewCell
    let indexPath = self.tableView.indexPathForCell(cell)
    let asset = DataSource.sharedInstance.assetAtIndexPath(indexPath!.section, row: indexPath!.row) // fix this
    
    destinationVC.asset = asset
    
    }
    
    println("preparing for segue")
    // Pass the selected object to the new view controller.
    }
    
    
    
    
    
    
    */
    
    
    // MARK: - Search Bar
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        println("text did begin editing")
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        println("did end editing")
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        println("cancel button clicked")
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println("search button clicked")
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        println("text changed..... \(searchText)")
        runSearch(searchText)
    }

    
    
    
    
    // MARK: - Search Functionality
    
    func runSearch(searchText: String){
        
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Media")
        
        let predicate = NSPredicate(format: "comments CONTAINS %@", searchText)
        fetchRequest.predicate = predicate
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.returnsDistinctResults = true
        fetchRequest.propertiesToFetch = NSArray(object: "comments") as [AnyObject]
        
        
        //3
        var error: NSError?
        
        self.uniqueSearchResults = []
        
        let uniqueFetchedResultsDictionary = managedContext.executeFetchRequest(fetchRequest, error: nil)
        println("fetched \(uniqueFetchedResultsDictionary!.count) results")
        
        println(uniqueFetchedResultsDictionary!.first)
        
        if let results = uniqueFetchedResultsDictionary{
            var resultsArray: [String] = []
            for var i = 0; i < results.count; i++ {
                if let result = (results[i] as? [String : String]){
                    if let comment = result["comments"]{
                        println(comment)
                        self.uniqueSearchResults.append(comment)
                    }
                }
            }
            println("\(self.uniqueSearchResults.count) unique search results")
        }

        
        
    }
    
    
    
    func getPHAssets(identifiers: [String]) -> [[PHAsset]]{
        
            
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
    

}
