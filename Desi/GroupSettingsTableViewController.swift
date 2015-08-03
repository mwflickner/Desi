//
//  GroupSettingsTableViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 7/6/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit

class GroupSettingsTableViewController: UITableViewController {
    
    var theGroup: DesiGroup!
    var userGroup: DesiUserGroup!

    override func viewDidLoad() {
        super.viewDidLoad()
        println("groupName is \(self.theGroup.groupName)")
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
        }
        
        
        // Configure the cell...

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
