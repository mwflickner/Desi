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
    //var tasks: [DesiTask]?
    var userGroupTasks: [DesiUserGroupTask]?
    
    var myUserGroupTasks = [DesiUserGroupTask]()
    var myDesiTasks = [DesiUserGroupTask]()
    var myOtherTasks = [DesiUserGroupTask]()
    
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
        if self.myUserGroupTasks.count != 0 {
            return 3
        }
        return 1
    }
    
    override func tableView( tableView: UITableView,  titleForHeaderInSection section: Int) -> String {
        switch(section) {
        case 0: return "New Task"
        case 1:  return "My Tasks"
        case 2: return "Other Tasks"
        default:  return ""
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section
        if self.myUserGroupTasks.count != 0 {
            if section == 0 {
                return 1
            }
            if section == 1 {
                return self.myDesiTasks.count
                
            }
            return self.myOtherTasks.count
        }
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        func setUpTaskCell(isDesi: Bool) -> DesiGroupsTableViewCell {
            let taskCell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as! DesiGroupsTableViewCell
            taskCell.groupNameLabel.text = self.myUserGroupTasks[indexPath.row].task.taskName
            if isDesi {
                taskCell.groupSumLabel.text = "You're up!"
            }
            else {
                taskCell.groupSumLabel.text = "You are not the Desi"
            }
            return taskCell
        }
        
        func setUpCreateTaskCell() -> TextFieldTableViewCell {
            let createTaskCell = tableView.dequeueReusableCellWithIdentifier("createTaskCell", forIndexPath: indexPath) as! TextFieldTableViewCell
            createTaskCell.button.setTitle("Create!", forState: UIControlState.Normal)
            createTaskCell.button.addTarget(self, action: "createNewTask:", forControlEvents: UIControlEvents.TouchUpInside)
            return createTaskCell
        }
        
        if self.myUserGroupTasks.count != 0 {
            if indexPath.section == 0 {
                return setUpCreateTaskCell()
            }
            if indexPath.section == 1 {
                return setUpTaskCell(true)
            }
            else {
                return setUpTaskCell(false)
            }
            
        }
        else {
            return setUpCreateTaskCell()
        }

    }
   /*
    @IBAction func deleteTask(sender: UIButton){
        sender.enabled = false
        var index: Int
        
        //other tasks
        if sender.tag > 199 {
            index = sender.tag - 200
            self.otherTasks[index].deleteInBackgroundWithBlock(<#block: PFBooleanResultBlock?##(Bool, NSError?) -> Void#>)
        }
        //myTasks
        else {
            index = sender.tag - 100
        }
        
        
    }
*/
    /*
    @IBAction func createNewTask(sender: UIButton){
        sender.enabled = false
        var indexPath: NSIndexPath
        if self.tasks != nil {
            indexPath = NSIndexPath(forRow: 0, inSection:2)
        }
        else {
            indexPath = NSIndexPath(forRow:0, inSection:0)
        }
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! TextFieldTableViewCell
        
        let newTask: DesiTask = DesiTask()
        newTask.taskName = cell.textField.text!
        cell.textField.text = ""
        newTask.members = self.userGroup.group.groupMembers
        newTask.theDesi = DesiUser.currentUser()!.username!
        newTask.groupId = self.userGroup.group.objectId!
        newTask.setDesiIndex()
        newTask.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                self.tasks.append(newTask)
                print("new task saved")
                
                //self.tasks.append(newTask)
                //self.tableView.reloadData()
                for ug in self.userGroups{
                    let newUGT: DesiUserGroupTask = DesiUserGroupTask()
                    newUGT.groupId = self.userGroup.group.objectId!
                    newUGT.taskId = newTask.objectId!
                    newUGT.task = newTask
                    
                    newUGT.userGroup = ug
                    
                    
                    if ug.username == DesiUser.currentUser()?.username{
                        newUGT.isDesi = true
                    }
                    else {
                        newUGT.isDesi = false
                    }
                    newUGT.saveInBackgroundWithBlock({
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            // The object has been saved.
                            print("usergrouptask saved")
                            self.tableView.reloadData()
                            
                        } else {
                            // There was a problem, check error.description
                            print("UserGroupTask Error: \(error)")
                            if error!.code == PFErrorCode.ErrorConnectionFailed.rawValue {
                                newUGT.saveEventually()
                            }
                        }
                    })
                }
                
            } else {
                // There was a problem, check error.description
                print("UserGroupTask Error: \(error)")
                if error!.code == PFErrorCode.ErrorConnectionFailed.rawValue {
    
                }
            }
        })
    }
    */
    
    /*
    @IBAction func backToGroupViewController(segue:UIStoryboardSegue) {
        if let theTaskTableViewController = segue.sourceViewController as? TaskTableViewController {
            let taskIndex = self.findTaskIndex(theTaskTableViewController.theTask)
            self.tasks[taskIndex] = theTaskTableViewController.theTask
            self.tableView.reloadData()
        }

    }
    */
    
    @IBAction func cancelToGroupVC(segue:UIStoryboardSegue){
        
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
    
    func getUserGroupTasks(){
        let ugTaskQuery = DesiUserGroupTask.query()
        ugTaskQuery!.includeKey("userGroup.group")
        ugTaskQuery!.whereKey("userGroup.group", equalTo: self.userGroup.objectId!)
        ugTaskQuery!.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) ugTasks.")
                    // Do something with the found objects
                    if let objects = objects as? [PFObject] {
                        let ugTasks = objects as? [DesiUserGroupTask]
                        self.userGroupTasks = ugTasks
                        
                        //store found userGroups in Localstore
                        
                        self.tableView.reloadData()
                        
                    }
                }
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }

    }
    
    func filterTasks(){
        for ugTask in self.myUserGroupTasks {
            if ugTask.isDesi {
                self.myDesiTasks.append(ugTask)
            }
            else {
                self.myOtherTasks.append(ugTask)
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "loadTask" {
            let path = self.tableView.indexPathForSelectedRow!
            let nav = segue.destinationViewController as! UINavigationController
            let aTaskView = nav.topViewController as! TaskTableViewController
            aTaskView.userGroup = self.userGroup
            
            if path.section == 1 {
                aTaskView.theTask = self.myDesiTasks[path.row].task
            }
            else if path.section == 2 {
                aTaskView.theTask = self.myOtherTasks[path.row].task
            }
        }
        
        if (segue.identifier == "GoToGroupSettings"){
            let nav = segue.destinationViewController as! UINavigationController
            let settingsView = nav.topViewController as! GroupSettingsTableViewController
            //settingsView.tasks = self.tasks
            settingsView.userGroup = self.userGroup
        }
        
    }


}
