//
//  TaskMembersTableViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 2/23/16.
//  Copyright © 2016 Desi. All rights reserved.
//

import UIKit

class TaskMembersTableViewController: UITableViewController {
    
    var userGroups = [DesiUserGroup]()
    var isMember = [Bool]()
    var outputUserGroups = [DesiUserGroup]()

    override func viewDidLoad() {
        super.viewDidLoad()
        for ug in self.userGroups {
            if self.outputUserGroups.contains(ug){
                self.isMember.append(true)
            }
            else {
                self.isMember.append(false)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userGroups.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark {
                if self.outputUserGroups.count > 1 {
                    cell.accessoryType = .None
                    self.outputUserGroups.removeAtIndex(indexPath.row)
                    self.isMember[indexPath.row] = false
                }
            }
            else {
                cell.accessoryType = .Checkmark
                self.outputUserGroups.insert(self.userGroups[indexPath.row], atIndex: indexPath.row)
            }
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memberCell", forIndexPath: indexPath) as! DesiTableViewCell
        let firstName = self.userGroups[indexPath.row].user.firstName
        let lastName = self.userGroups[indexPath.row].user.lastName
        cell.label1.text = "\(firstName) \(lastName)"
        if self.isMember[indexPath.row]{
            cell.accessoryType = .Checkmark
        }
        else {
            cell.accessoryType = .None
        }
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "backToCreateTaskView" {
            let createTaskView = segue.destinationViewController as! CreateTaskTableViewController
            createTaskView.outputUserGroups = self.outputUserGroups
            createTaskView.updateMembersLabel()
        }
    }


}
