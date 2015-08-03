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
    
    var myUserGroups: [DesiUserGroup]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //self.navigationController!.navigationBar.barTintColor = UIColor.blueColor()
        //self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        if (self.myUserGroups == nil){
            println("yoo")
        }
        //var userGroupIds = DesiUser.currentUser()!.userGroups
        
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if myUserGroups != nil {
            return self.myUserGroups.count + 1
        }
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0){
            var mainCell = tableView.dequeueReusableCellWithIdentifier("ProfileMainCell", forIndexPath: indexPath) as! ProfileMainTableViewCell
            mainCell.usernameLabel.text = DesiUser.currentUser()!.username
            mainCell.nameLabel.text = DesiUser.currentUser()!.firstName + " " + DesiUser.currentUser()!.lastName
            mainCell.desiPointsLabel.text = "Desi Points: " + String(DesiUser.currentUser()!.desiPoints)
            mainCell.viewFriendsButton.enabled = false
            mainCell.viewFriendsButton.hidden = true
            self.tableView.rowHeight = 200
            return mainCell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DesiGroupCell", forIndexPath: indexPath) as! DesiGroupsTableViewCell
        // Configure the cell...
        let userGroup = myUserGroups[indexPath.row - 1] as DesiUserGroup
        cell.groupNameLabel.text = userGroup.group.groupName
        cell.groupSumLabel.text = userGroup.group.theDesi.username + " is the Desi"
        //cell.groupImgView.image = group.groupImg
        self.tableView.rowHeight = 60
        return cell
        
    }
    
    
    @IBAction func cancelToDesiGroupsViewController(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func createNewDesiGroup(segue:UIStoryboardSegue) {
        if let newDesiGroupTableViewController = segue.sourceViewController as? NewDesiGroupTableViewController {
            myUserGroups.append(newDesiGroupTableViewController.myNewUserGroup)
            self.tableView.reloadData()
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
        //-1 to account for the profile cell
        print("group is \(myUserGroups[indexPath.row - 1].group.groupName)\n")
        return myUserGroups[indexPath.row - 1]
    }
    
    func groupAtIndexPath(indexPath: NSIndexPath) -> DesiGroup {
        //-1 to account for the profile cell
        print("group is \(myUserGroups[indexPath.row - 1].group.groupName)\n")
        return myUserGroups[indexPath.row - 1].group
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
            
            //user has never been in group before
            if aGroupView.userGroup.user != DesiUser.currentUser() {
                aGroupView.userGroup.user = DesiUser.currentUser()!
                aGroupView.userGroup.saveInBackgroundWithBlock({
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                        println("usergroup added user pointer")
                    } else {
                        // There was a problem, check error.description
                        println("UserGroup Error: \(error)")
                        if error!.code == PFErrorCode.ErrorConnectionFailed.rawValue {
                            aGroupView.userGroup.saveEventually()
                        }
                    }
                })
            }
        }
        
    }

}
