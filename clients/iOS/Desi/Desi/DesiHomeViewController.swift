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
    
    var myUserGroups = [DesiUserGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.getLocalUserGroups()
        
        if (self.myUserGroups.count == 0){
            print("yoo")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return self.myUserGroups.count
        }
        return 0
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DesiGroupCell", forIndexPath: indexPath) as! DesiGroupsTableViewCell
        let userGroup = myUserGroups[indexPath.row] as DesiUserGroup
        cell.groupNameLabel.text = userGroup.group.groupName
        //cell.groupImgView.image = group.groupImage
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
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
    
    @IBAction func cancelToDesiGroupsViewController(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func createNewDesiGroup(segue:UIStoryboardSegue) {
        if let newGroupViewController = segue.sourceViewController as? NewGroupViewController {
            myUserGroups.append(newGroupViewController.myNewUserGroup)
            DesiUserGroup.pinAllInBackground(self.myUserGroups, withName:"MyUserGroups")
            self.tableView.reloadData()
        }
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
