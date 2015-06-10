//
//  SearchVC.swift
//  Pintu
//
//  Created by Roshan Mahanama on 10/06/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

import UIKit
import CoreData

class SearchVC: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    @IBOutlet var searchBar: UISearchBar!
    // core data
    var searchResults = [NSManagedObject]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self

        // Do any additional setup after loading the view.
        
      
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
        
        
        
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Media")
        
        let predicate = NSPredicate(format: "comments CONTAINS %@", searchText)
        fetchRequest.predicate = predicate
        
        
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            self.searchResults = results
            println("found \(results.count) saved comments")
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.searchResults.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell;
        
        
        return cell
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
