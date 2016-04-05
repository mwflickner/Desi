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
    var myLogs = [DesiUserGroupTaskLog]()
    var refreshControl = UIRefreshControl()
    var hasViewedLog = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.refreshControl.addTarget(self, action: #selector(getUserGroups), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        self.refreshControl.beginRefreshing()
        //self.getLocalUserGroups()
        
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
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segControl.selectedSegmentIndex == 0 {
            if section == 1 {
                return self.myUserGroups.count
            }
            return 0
        }
        return self.myLogs.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if segControl.selectedSegmentIndex == 0 {
            if section == 1 {
                return "My Groups"
            }
            return nil
        }
        return "My Log"
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if segControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("DesiGroupCell", forIndexPath: indexPath) as! DesiGroupsTableViewCell
            let userGroup = myUserGroups[indexPath.row] as DesiUserGroup
            cell.groupNameLabel.text = userGroup.group.groupName
            //cell.groupImgView.image = group.groupImage
            return cell
        }
        let logCell = tableView.dequeueReusableCellWithIdentifier("LogCell", forIndexPath: indexPath) as! DesiTableViewCell
        let logEntry = self.myLogs[indexPath.row]
        let firstName = logEntry.userGroupTask.userGroup.user.firstName
        let lastName = logEntry.userGroupTask.userGroup.user.lastName
        let verb = logEntry.actionTypeToVerb()
        let taskName = logEntry.userGroupTask.task.taskName
        let groupName = logEntry.userGroupTask.userGroup.group.groupName
        logCell.label1.text = "\(firstName) \(lastName) \(verb) for \(taskName) in \(groupName) at \(logEntry.createdAt!)"
        logCell.label2.text = logEntry.actionMessage
        return logCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if segControl.selectedSegmentIndex == 0 {
            return 60
        }
        return 120
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
            //store found userGroups in Localstore
            DesiUserGroup.pinAllInBackground(self.myUserGroups, withName:"MyUserGroups")
            if let _ = self.tableView {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Queries
    
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
        let user = DesiUser.currentUser()!
        let userGroupQuery = DesiUserGroup.query()
        userGroupQuery?.whereKey("user", equalTo: user)
        
        let userGroupTaskQuery = DesiUserGroupTask.query()
        userGroupTaskQuery?.whereKey("userGroup", matchesQuery: userGroupQuery!)
        
        let logQuery = DesiUserGroupTaskLog.query()
        logQuery?.includeKey("userGroupTask")
        logQuery?.includeKey("userGroupTask.userGroup")
        logQuery?.includeKey("userGroupTask.task")
        logQuery?.includeKey("userGroupTask.userGroup.user")
        logQuery?.whereKey("userGroupTask", matchesQuery: userGroupTaskQuery!)
        logQuery?.addDescendingOrder("createdAt")
        logQuery?.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            guard error == nil else {
                return
            }
            
            guard let logEntries = objects as? [DesiUserGroupTaskLog] else {
                return
            }
            
            self.myLogs = logEntries
            self.refreshControl.endRefreshing()
            if self.segControl.selectedSegmentIndex == 1 {
                self.tableView.reloadData()
            }
            print(logEntries.count)
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
