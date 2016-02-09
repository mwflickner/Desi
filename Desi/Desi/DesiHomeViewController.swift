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
        
        //self.navigationController!.navigationBar.barTintColor = UIColor.blueColor()
        //self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
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
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myUserGroups.count + 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0){
            let mainCell = tableView.dequeueReusableCellWithIdentifier("ProfileMainCell", forIndexPath: indexPath) as! ProfileMainTableViewCell
            mainCell.usernameLabel.text = DesiUser.currentUser()!.username
            mainCell.nameLabel.text = DesiUser.currentUser()!.firstName + " " + DesiUser.currentUser()!.lastName
            mainCell.desiPointsLabel.text = "Desi Points: " + String(DesiUser.currentUser()!.desiScore)
            mainCell.viewFriendsButton.enabled = false
            mainCell.viewFriendsButton.hidden = true
            return mainCell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DesiGroupCell", forIndexPath: indexPath) as! DesiGroupsTableViewCell
        let userGroup = myUserGroups[indexPath.row - 1] as DesiUserGroup
        cell.groupNameLabel.text = userGroup.group.groupName
        //cell.groupImgView.image = group.groupImage
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        }
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
        for var i = 0; i < myUserGroups.count; ++i {
            if ((userGroup.objectId == myUserGroups[i].objectId)){
                return i
            }
        }
        return -1
        //group not found
    }
    
    func userGroupAtIndexPath(indexPath: NSIndexPath) -> DesiUserGroup {
        //-1 to account for the profile cell
        print("group is \(myUserGroups[indexPath.row - 1].group.groupName)\n", terminator: "")
        return myUserGroups[indexPath.row - 1]
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
            let groupIndex = self.findUserGroupIndex(theGroupTableViewController.userGroups[0])
            //self.myUserGroups[groupIndex] = theGroupTableViewController.userGroups
            self.tableView.reloadData()
        }
    }
    
    @IBAction func leaveGroupFromSettings(segue:UIStoryboardSegue){
        /*
        if let groupSettingsViewController = segue.sourceViewController as? GroupSettingsTableViewController {
            for var i = 0; i < self.myUserGroups.count; ++i {
                if self.myUserGroups[i].objectId == groupSettingsViewController.userGroup.objectId {
                    self.myUserGroups.removeAtIndex(i)
                    println("ug removed")
                    break
                }
            }
            var oldUG = groupSettingsViewController.userGroup
            // delete the userGroup
            groupSettingsViewController.userGroup.deleteInBackgroundWithBlock{
                (success: Bool, error: NSError?) -> Void in
                if success {
                    // group deleted
                    println("deleted")
                    //sender.enabled = true
                    self.tableView.reloadData()
                    groupSettingsViewController.theGroup.nextDesi()
                    if oldUG.isGroupAdmin {
                        groupSettingsViewController.theGroup.theDesi.isGroupAdmin = true
                    }
                    groupSettingsViewController.theGroup.theDesi.saveInBackgroundWithBlock({
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            // The object has been saved.
                            println("round2")
                            self.tableView.reloadData()
                           // self.performSegueWithIdentifier("leaveGroupFromSettingsSegue", sender: self)
                        }
                        else {
                            // There was a problem, check error.description
                            println("usergroup error: \(error)")
                            if error!.code == PFErrorCode.ErrorConnectionFailed.rawValue {
                                groupSettingsViewController.theGroup.theDesi.saveEventually()
                            }
                        }
                    })
                    
                }
                else {
                    if error!.code == PFErrorCode.ErrorConnectionFailed.rawValue {
                        groupSettingsViewController.userGroup.deleteEventually()
                    }
                }
            }
        }
        */
    }
    
    
    func getUserGroups(){
        let query = DesiUserGroup.query()
        query!.includeKey("group")
        query!.whereKey("user", equalTo: DesiUser.currentUser()!)
        query!.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    let userGroups = objects as? [DesiUserGroup]
                    self.myUserGroups = userGroups!
                    
                    //store found userGroups in Localstore
                    DesiUserGroup.pinAllInBackground(self.myUserGroups, withName:"MyUserGroups")
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func getLocalUserGroups(){
        let queryLocal = DesiUserGroup.query()
        queryLocal!.includeKey("group")
        queryLocal!.whereKey("user", equalTo: DesiUser.currentUser()!)
        queryLocal!.fromLocalDatastore()
        queryLocal!.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores. Swag.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    let userGroups = objects as? [DesiUserGroup]
                    self.myUserGroups = userGroups!
                    self.tableView.reloadData()
                }
            }
            else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
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
            //aGroupView.theGroup = groupAtIndexPath(path)
            aGroupView.myUserGroup = userGroupAtIndexPath(path)
            aGroupView.getUserGroupTasksForGroup()
            aGroupView.getUserGroupsForGroup(aGroupView.myUserGroup.group)
        }
        
    }

}
