//
//  DesiGroupsTableViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 5/25/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse

class DesiGroupsTableViewController: UITableViewController {

    var myUserGroups: [DesiUserGroup]!
    var groupToGoTo: DesiGroup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            println("Object has been saved.")
        }
        */
        
        /*
        let query = DesiUserGroup.query()
        query!.whereKey("username", equalTo: DesiUser.currentUser()!.username!)
        query!.includeKey("group.theDesi")
        query!.fromLocalDatastore()
        query!.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    // The find succeeded.
                    println("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects as? [PFObject] {
                        let userGroups = objects as? [DesiUserGroup]
                        self.myUserGroups = userGroups
                        
                        self.tableView.reloadData()
                        
                    }
                }
                
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        */

        
        
        var userGroupIds = DesiUser.currentUser()!.userGroups
        
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
        if self.myUserGroups == nil {
            return 0
        }
        return myUserGroups.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DesiGroupCell", forIndexPath: indexPath) as! DesiGroupsTableViewCell

        // Configure the cell...
        let userGroup = myUserGroups[indexPath.row] as DesiUserGroup
        cell.groupNameLabel.text = userGroup.group.groupName
        cell.groupSumLabel.text = userGroup.group.theDesi.username + " is the Desi"
        //cell.groupImgView.image = group.groupImg
        return cell
        
    }
    
    
    @IBAction func cancelToDesiGroupsViewController(segue:UIStoryboardSegue) {
        
    }
    
    
    @IBAction func createNewDesiGroup(segue:UIStoryboardSegue) {
        if let newDesiGroupTableViewController = segue.sourceViewController as? NewDesiGroupTableViewController {
            myUserGroups.append(newDesiGroupTableViewController.newUserGroup)
            let indexPath = NSIndexPath(forRow: myUserGroups.count-1, inSection: 0)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    @IBAction func backtoDesiGroupsViewController(segue:UIStoryboardSegue) {
        if let theGroupTableViewController = segue.sourceViewController as? TheGroupTableViewController {
            var groupIndex = self.findUserGroupIndex(theGroupTableViewController.userGroup)
            self.myUserGroups[groupIndex] = theGroupTableViewController.userGroup
            self.tableView.reloadData()
        }
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
    
    /*override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Row \(indexPath.row) selected")
        self.groupToGoTo = myGroups[indexPath.row]
        println("Group = \(self.groupToGoTo.groupName)")
        //performSegueWithIdentifier("loadGroup", sender: self)
    }
    */
    
    func userGroupAtIndexPath(indexPath: NSIndexPath) -> DesiUserGroup {
        print("group is \(myUserGroups[indexPath.row].group.groupName)\n")
        return myUserGroups[indexPath.row]
    }
    
    func groupAtIndexPath(indexPath: NSIndexPath) -> DesiGroup {
        print("group is \(myUserGroups[indexPath.row].group.groupName)\n")
        return myUserGroups[indexPath.row].group
    }
    
    func findUserGroupIndex(userGroup: DesiUserGroup) -> Int {
        for var i = 0; i < myUserGroups.count; ++i {
            if ((userGroup.objectId == myUserGroups[i].objectId) && (userGroup.group.groupName == myUserGroups[i].group.groupName)){
                return i
            }
        }
        return -1
        //group not found
    }
    
    /*
    func findGroup(group: DesiGroup) -> DesiGroup {
        for var i = 0; i < myGroups.count; ++i {
            if ((group.groupId == myGroups[i].groupId) && (group.groupName == myGroups[i].groupName)){
                return myGroups[i]
            }
        }
        return nil
    }
    */
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "loadGroup" {
            let path = self.tableView.indexPathForSelectedRow()!
            let nav = segue.destinationViewController as! UINavigationController
            var aGroupView = nav.topViewController as! TheGroupTableViewController
            aGroupView.theGroup = groupAtIndexPath(path)
            aGroupView.userGroup = userGroupAtIndexPath(path)
        }
    }
    

}
