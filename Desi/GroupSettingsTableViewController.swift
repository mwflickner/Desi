//
//  GroupSettingsTableViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 7/6/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse

class GroupSettingsTableViewController: UITableViewController {
    
    var theGroup: DesiGroup!
    var userGroup: DesiUserGroup!

    override func viewDidLoad() {
        super.viewDidLoad()
        println("groupName is \(self.theGroup.groupName)")
        println("\(DesiUser.currentUser()?.username)")
        self.navigationItem.title = "Group Settings"


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
        if userGroup.isGroupAdmin {
            return 2
        }
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
            return 2
        }
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("bigButtonCell", forIndexPath: indexPath) as! TextFieldTableViewCell
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.button.setTitle("View Members", forState: UIControlState.Normal)
                cell.button.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
                cell.button.addTarget(self, action: "viewMembers:", forControlEvents: UIControlEvents.TouchUpInside)
                return cell
            }
            cell.button.setTitle("Leave Group", forState: UIControlState.Normal)
            cell.button.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
            cell.button.addTarget(self, action: "leaveGroup:", forControlEvents: UIControlEvents.TouchUpInside)
            return cell
        }
        else {
            cell.button.setTitle("Delete Group", forState: UIControlState.Normal)
            cell.button.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
            cell.button.addTarget(self, action: "deleteGroup:", forControlEvents: UIControlEvents.TouchUpInside)
            return cell
        }
    }
    
    @IBAction func viewMembers(sender: UIButton){
        println("view")
        //performSegueWithIdentifier("goToViewGroupMembers", sender: self)
    }
    
    @IBAction func leaveGroup(sender: UIButton){
        sender.enabled = false
        if self.userGroup.isDesi {
            println("got here")
            self.theGroup.nextDesi()
        }
        // remove username from group members
        for var i = 0; i < self.theGroup.groupMembers.count; ++i {
            println("group : \(theGroup.groupMembers[i]) current user: \(DesiUser.currentUser()?.username)")
            if theGroup.groupMembers[i] == DesiUser.currentUser()?.username {
                println("removing")
                theGroup.groupMembers.removeAtIndex(i)
                --theGroup.numberOfUsers
                break
            }
        }
        
        // remove usergroup from the user's list of groups
        for var i = 0; i < DesiUser.currentUser()?.userGroups.count; ++i{
            println("user : \(DesiUser.currentUser()?.userGroups[i]) self.userGroup: \(self.userGroup.objectId)")
            if DesiUser.currentUser()?.userGroups[i] == self.userGroup.objectId{
                DesiUser.currentUser()!.userGroups.removeAtIndex(i)
                break
            }
        }
        self.performSegueWithIdentifier("leaveGroupFromSettingsSegue", sender: self)
        
    }
    
    @IBAction func deleteGroup(sender: UIButton){
        sender.enabled = false
        for ug in self.theGroup.groupMembers {
            
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "leaveGroupFromSettingsSegue" {
            //print yo whats up
        }
    }


}
