//
//  LogViewController.swift
//  RWRealmStarterProject
//
//  Created by Bill Kastanakis on 8/7/14.
//  Copyright (c) 2014 Bill Kastanakis. All rights reserved.
//

import UIKit
import Realm
import MapKit

class LogViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
  
  var specimens = []
  var searchResults = []
  
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  
  var searchController : UISearchController!
  
  // MARK: - SearchBar Delegate
  // You can use objectsWhere but let's introduce predicates! :]
  
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    let searchString = searchController.searchBar.text
        
    let searchResultsController = searchController.searchResultsController as! UITableViewController
    searchResultsController.tableView.reloadData()
  }
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var searchResultsController = UITableViewController(style: .Plain) as UITableViewController
    searchResultsController.tableView.delegate = self
    searchResultsController.tableView.dataSource = self
    searchResultsController.tableView.rowHeight = 63
    searchResultsController.tableView.registerClass(LogCell.self, forCellReuseIdentifier: "LogCell")
    
    searchController = UISearchController(searchResultsController: searchResultsController)
    searchController.searchResultsUpdater = self
    searchController.searchBar.sizeToFit()
    searchController.searchBar.tintColor = UIColor.whiteColor()
    searchController.searchBar.delegate = self
    searchController.searchBar.barTintColor = UIColor(red: 0, green: 104.0/255.0, blue: 55.0/255.0, alpha: 1.0)
    tableView.tableHeaderView?.addSubview(searchController.searchBar)
    
    definesPresentationContext = true;
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if (searchController.active) {
      return Int(searchResults.count)
    } else {
      return Int(specimens.count)
    }
    
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
    var cell = tableView.dequeueReusableCellWithIdentifier("LogCell") as! LogCell
    
    return cell
    
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {

    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if (segue.identifier == "Edit") {
      let controller = segue.destinationViewController as! AddNewEntryController
      
      let indexPath = tableView.indexPathForSelectedRow()
      
      if searchController.active {
        let searchResultsController = searchController.searchResultsController as! UITableViewController
        let indexPathSearch = searchResultsController.tableView.indexPathForSelectedRow()
        
      }
      
    }
  }
  
  //MARK: - Actions

  @IBAction func scopeChanged(sender: AnyObject) {
    
  }
  
  
}
