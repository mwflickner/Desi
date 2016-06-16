//
//  DesiHomeViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 7/31/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse

class DesiHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segControl: UISegmentedControl!
    
    var myUserGroups = [DesiUserGroup]()
    var myLogs = [DesiUserGroupLog]()
    var refreshControl = UIRefreshControl()
    
    var hasViewedLog = false
    var oldestLoadedLog: DesiUserGroupLog?
    var loadingMoreLogs: Bool = false
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.activityIndicator.hidesWhenStopped = true
        self.tableView.tableFooterView = self.activityIndicator
        self.refreshControl.addTarget(self, action: #selector(getUserGroups), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
        //self.refreshControl.beginRefreshing()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.navigationItem.title = "Desi"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if segControl.selectedSegmentIndex == 0 {
            return 2
        }
        return myLogs.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segControl.selectedSegmentIndex == 0 {
            if section == 1 {
                return self.myUserGroups.count
            }
            return 0
        }
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if segControl.selectedSegmentIndex == 0 {
            if section == 1 {
                return "My Groups:"
            }
        }
        else {
            if section == 0 {
                return "My Log:"
            }
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if segControl.selectedSegmentIndex == 1 {
            if section < self.myLogs.count {
                return 10
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if self.segControl.selectedSegmentIndex == 1 {
            if !loadingMoreLogs && indexPath.section == self.myLogs.count - 1 && self.myLogs.count >= 10 && self.tableView.tableFooterView != nil {
                print(self.loadingMoreLogs)
                self.activityIndicator.startAnimating()
                self.loadingMoreLogs = true
                self.getTaskLogForUser()
            }
        }
        //self.tableView.tableFooterView = nil
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if segControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("DesiGroupCell", forIndexPath: indexPath) as! DesiGroupsTableViewCell
            let userGroup = myUserGroups[indexPath.row] as DesiUserGroup
            cell.groupNameLabel.text = userGroup.group.groupName
            //cell.groupImgView.image = group.groupImage
            return cell
        }
        if indexPath.row == 0 {
            let logCell = tableView.dequeueReusableCellWithIdentifier("LogCell", forIndexPath: indexPath) as! DesiTableViewCell
            let logEntry = self.myLogs[indexPath.section]
            let firstName = logEntry.userGroup.user.firstName
            let lastName = logEntry.userGroup.user.lastName
            let verb = logEntry.actionTypeToVerb()!
            let taskName = logEntry.task.taskName
            let groupName = logEntry.userGroup.group.groupName
            let date = dateToString(logEntry.createdAt!)
            let cost = logEntry.points >= 0 ? "(+\(logEntry.points))" : "(\(logEntry.points))"
            logCell.label1.text = "\(firstName) \(lastName) \(verb) \(cost) \(taskName) in \(groupName) on \(date)"
            logCell.separatorInset = UIEdgeInsetsMake(0.1, logCell.bounds.size.width, 0.1, 0.1)
            return logCell
        }
        let logCell = tableView.dequeueReusableCellWithIdentifier("LogMessageCell", forIndexPath: indexPath) as! DesiTableViewCell
        let logEntry = self.myLogs[indexPath.section]
        logCell.label2.text = logEntry.actionMessage
        return logCell

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if segControl.selectedSegmentIndex == 0 {
            return 60
        }
        if indexPath.row == 0 {
            return 80
        }
        return 80
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
    
    func findUserGroupIndex(userGroup: DesiUserGroup) -> Int {
        for i in 0 ..< myUserGroups.count {
            if ((userGroup.objectId == myUserGroups[i].objectId)){
                return i
            }
        }
        return -1
        //group not found
    }
    
    func userGroupAtIndexPath(indexPath: NSIndexPath) -> DesiUserGroup {
        //-1 to account for the profile cell
        print("group is \(myUserGroups[indexPath.row ].group.groupName)\n", terminator: "")
        return myUserGroups[indexPath.row]
    }
    
    @IBAction func cancelToDesiHomeViewController(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func backtoDesiGroupsViewController(segue:UIStoryboardSegue) {
        if let theGroupTableViewController = segue.sourceViewController as? GroupTableViewController {
            //let groupIndex = self.findUserGroupIndex(theGroupTableViewController.userGroups[0])
            //self.myUserGroups[groupIndex] = theGroupTableViewController.userGroups
            self.tableView.reloadData()
        }
    }
    
    @IBAction func leaveGroupFromSettings(segue:UIStoryboardSegue){
        
    }
    
    // MARK: - Queries
    
    func getUserGroups(){
        let query = DesiUserGroup.query()
        query!.includeKey("group")
        query!.whereKey("user", equalTo: DesiUser.currentUser()!)
        query!.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            guard error == nil else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                return
            }
            // The find succeeded.
            print("Successfully retrieved \(objects!.count) scores.")
            // Do something with the found objects
            guard let userGroups = objects as? [DesiUserGroup] else {
                return
            }
            self.myUserGroups = userGroups
            self.refreshControl.endRefreshing()
            //self.refreshControl.hidden = true
            //store found userGroups in Localstore
            DesiUserGroup.pinAllInBackground(self.myUserGroups, withName:"MyUserGroups")
            if let _ = self.tableView {
                self.tableView.reloadData()
            }
        }
    }
    
    func getLocalUserGroups(){
        let queryLocal = DesiUserGroup.query()
        queryLocal!.includeKey("group")
        queryLocal!.whereKey("user", equalTo: DesiUser.currentUser()!)
        queryLocal!.fromLocalDatastore()
        queryLocal!.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            guard error == nil else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                return
            }
            // The find succeeded.
            print("Successfully retrieved \(objects!.count) scores. Swag.")
            // Do something with the found objects
            guard let userGroups = objects as? [DesiUserGroup] else {
                return
            }
            self.myUserGroups = userGroups
            self.tableView.reloadData()
        }
    }
    
    func getTaskLogForUser(){
        let shouldLoadOldLogs = self.oldestLoadedLog != nil && self.loadingMoreLogs
        let user = DesiUser.currentUser()!
        let userGroupQuery = DesiUserGroup.query()
        userGroupQuery?.whereKey("user", equalTo: user)
        
        let bigUgQuery = DesiUserGroup.query()
        bigUgQuery?.whereKey("group", matchesKey: "group", inQuery: userGroupQuery!)
        
        let logQuery = DesiUserGroupLog.query()
        logQuery?.includeKey("userGroup")
        logQuery?.includeKey("task")
        logQuery?.includeKey("userGroup.user")
        logQuery?.includeKey("userGroup.group")
        logQuery?.whereKey("userGroup", matchesQuery: bigUgQuery!)
        if shouldLoadOldLogs {
            logQuery?.whereKey("createdAt", lessThan: (self.oldestLoadedLog?.createdAt)!)
        }
        logQuery?.addDescendingOrder("createdAt")
        logQuery?.limit = 10
        logQuery?.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            guard error == nil else {
                return
            }
            
            guard let logEntries = objects as? [DesiUserGroupLog] else {
                return
            }
            self.oldestLoadedLog = logEntries.last
            if shouldLoadOldLogs {
                self.myLogs += logEntries
                self.loadingMoreLogs = false
                self.activityIndicator.stopAnimating()
                if logEntries.count == 0 {
                    self.tableView.tableFooterView = nil
                }
            }
            else {
                self.refreshControl.endRefreshing()
                self.myLogs = logEntries
            }
        
            self.tableView.reloadData()
        }
    }
    
    @IBAction func segControlChanged(sender: UISegmentedControl){
        sender.enabled = false
        if !hasViewedLog {
            self.getTaskLogForUser()
            self.hasViewedLog = true
        }
        if sender.selectedSegmentIndex == 1 {
            self.refreshControl.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
            self.refreshControl.addTarget(self, action: #selector(getTaskLogForUser), forControlEvents: UIControlEvents.ValueChanged)
        }
        else {
            self.refreshControl.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
            self.refreshControl.addTarget(self, action: #selector(getUserGroups), forControlEvents: UIControlEvents.ValueChanged)
        }
        self.tableView.reloadData()
        sender.enabled = true
        
    }


    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "loadGroup" {
            let path = self.tableView.indexPathForSelectedRow!
            let nav = segue.destinationViewController as! UINavigationController
            let aGroupView = nav.topViewController as! GroupTableViewController
            aGroupView.myUserGroup = userGroupAtIndexPath(path)
            
            aGroupView.getUserGroupTasksForGroup()
        }
        
    }

}
