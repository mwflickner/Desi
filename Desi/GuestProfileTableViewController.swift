//
//  GuestProfileTableViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 7/23/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit

class GuestProfileTableViewController: UITableViewController {
    
    var theProfile: DesiUser!

    override func viewDidLoad() {
        super.viewDidLoad()

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
        return 2
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let guestCell = tableView.dequeueReusableCellWithIdentifier("ProfileGuestViewCell", forIndexPath: indexPath) as! ProfileGuestViewTableViewCell

        /*
        if (indexPath.row == 0){
            var mainCell = tableView.dequeueReusableCellWithIdentifier("ProfileMainCell", forIndexPath: indexPath) as! ProfileMainTableViewCell
            mainCell.usernameLabel.text = theProfile.username
            mainCell.desiPointsLabel.text = "Desi Points: " + String(theProfile.desiPoints)
            self.tableView.rowHeight = 300
            return mainCell
        }
        
                // Configure the cell...
        
        //gotta change this soon
        for friendId in DesiUser.currentUser()!.friendList.friendships{
            if friendId == theProfile.objectId {
                guestCell.friendButton.setTitle("Unfriend", forState: UIControlState.Normal)
                return guestCell
            }
        }
        guestCell.friendButton.setTitle("Add Friend", forState: UIControlState.Normal)*/
        return guestCell
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
