//
//  GroupTableViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 8/20/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse

class GroupTableViewController: UITableViewController {

    //var theGroup: DesiGroup!
    var userGroup: DesiUserGroup!
    var tasks: [DesiTask]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.userGroup.group.groupName
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
        if tasks != nil {
            return tasks.count
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let taskCell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as! DesiGroupsTableViewCell
        taskCell.groupNameLabel.text = self.tasks[indexPath.row].taskName
        //taskCell.groupSumLabel.text = self.tasks[indexPath.row].theDesi.userGroup.username + "is the Desi"
        
        // Configure the cell...

        return taskCell
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
        if segue.identifier == "loadTask" {
            let path = self.tableView.indexPathForSelectedRow()!
            let nav = segue.destinationViewController as! UINavigationController
            var aTaskView = nav.topViewController as! TaskTableViewController
            aTaskView.userGroup = self.userGroup
            aTaskView.task = self.tasks[path.row]
            var ugTaskQuery = DesiUserGroupTask.query()
            ugTaskQuery!.whereKey("taskId", equalTo: aTaskView.task.objectId!)
            ugTaskQuery!.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        // The find succeeded.
                        println("Successfully retrieved \(objects!.count) scores.")
                        // Do something with the found objects
                        if let objects = objects as? [PFObject] {
                            let ugTasks = objects as? [DesiUserGroupTask]
                            aTaskView.tasks = tasks
                            
                            //store found userGroups in Localstore
                            
                            aTaskView.tableView.reloadData()
                            
                        }
                    }
                    
                } else {
                    // Log details of the failure
                    println("Error: \(error!) \(error!.userInfo!)")
                }
            }

        }
        
    }


}
