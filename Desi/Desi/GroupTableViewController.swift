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
    var userGroups: [DesiUserGroup]!
    var myTasks = [DesiTask]()
    var otherTasks = [DesiTask]()
    
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
        if self.tasks != nil {
            return 3
        }
        return 1
        
    }
    
    override func tableView( tableView: UITableView,  titleForHeaderInSection section: Int) -> String {
        switch(section) {
        case 0: return "New Task"
           // break
        case 1:  return "My Tasks"
            //break
        case 2: return "Other Tasks"
            //break
        default:  return ""
            //break
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section
        self.myTasks = [DesiTask]()
        self.otherTasks = [DesiTask]()
        if self.tasks != nil {
            for task in self.tasks {
                if task.theDesi == DesiUser.currentUser()!.username {
                    self.myTasks.append(task)
                }
                else {
                    self.otherTasks.append(task)
                }
            }
            if section == 0 {
                return 1
            }
            if section == 1 {
                return self.myTasks.count
                
            }
            return self.otherTasks.count
        }
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.tasks != nil {
            if indexPath.section == 0 {
                let createTaskCell = tableView.dequeueReusableCellWithIdentifier("createTaskCell", forIndexPath: indexPath) as! TextFieldTableViewCell
                createTaskCell.button.setTitle("Create!", forState: UIControlState.Normal)
                createTaskCell.button.addTarget(self, action: "createNewTask:", forControlEvents: UIControlEvents.TouchUpInside)
                return createTaskCell

            }
            if indexPath.section == 1 {
                let taskCell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as! DesiGroupsTableViewCell
                taskCell.groupNameLabel.text = self.myTasks[indexPath.row].taskName
                taskCell.groupSumLabel.text = "You're up!"
                if !self.userGroup.isGroupAdmin {
                    taskCell.button.hidden = true
                }
                else {
                    taskCell.button.addTarget(self, action: "deleteTask:", forControlEvents: UIControlEvents.TouchUpInside)
                    taskCell.button.tag = 100 + indexPath.row
                }
                return taskCell
                
            }
            else {
                let taskCell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as! DesiGroupsTableViewCell
                taskCell.groupNameLabel.text = self.otherTasks[indexPath.row].taskName
                taskCell.groupSumLabel.text = self.otherTasks[indexPath.row].theDesi + "'s up!"
                if !self.userGroup.isGroupAdmin {
                    taskCell.button.hidden = true
                }
                else {
                    taskCell.button.addTarget(self, action: "deleteTask:", forControlEvents: UIControlEvents.TouchUpInside)
                    taskCell.button.tag = 200 + indexPath.row
                }
                return taskCell
            }
            
        }
        else {
            let createTaskCell = tableView.dequeueReusableCellWithIdentifier("createTaskCell", forIndexPath: indexPath) as! TextFieldTableViewCell
            createTaskCell.button.setTitle("Create!", forState: UIControlState.Normal)
            createTaskCell.button.addTarget(self, action: "createNewTask:", forControlEvents: UIControlEvents.TouchUpInside)
            return createTaskCell
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

    @IBAction func backToGroupViewController(segue:UIStoryboardSegue) {
        if let theTaskTableViewController = segue.sourceViewController as? TaskTableViewController {
            let taskIndex = self.findTaskIndex(theTaskTableViewController.theTask)
            self.tasks[taskIndex] = theTaskTableViewController.theTask
            self.tableView.reloadData()
        }

    }
    
    @IBAction func cancelToGroupVC(segue:UIStoryboardSegue){
        
    }
    
    func findTaskIndex(task: DesiTask) -> Int {
        for var i = 0; i < tasks.count; ++i {
            if (task.objectId == tasks[i].objectId){
                return i
            }
        }
        return -1
        //group not found
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
        let userGroupTaskQuery = DesiUserGroupTask.query()
        taskQuery!.whereKey("groupId", equalTo: self.userGroup.group.objectId!)
        
        let userGroupQuery = DesiUserGroup.query()
        userGroupQuery!.whereKey("groupId", equalTo: userGroupAtIndexPath(path).group.objectId!)
        
        taskQuery!.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                userGroupQuery?.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]?, error: NSError?) -> Void in
                    if error == nil {
                        dispatch_async(dispatch_get_main_queue()){
                            if let objects = objects as? [PFObject]{
                                let userGroups = objects as? [DesiUserGroup]
                                self.userGroups = userGroups
                                print("done")
                            }
                        }
                    }
                    else {
                        print("error: \(error!) \(error!.userInfo)")
                    }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects as? [PFObject] {
                        let tasks = objects as? [DesiTask]
                        self.tasks = tasks
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
                aTaskView.theTask = self.myTasks[path.row]
            }
            else if path.section == 2 {
                aTaskView.theTask = self.otherTasks[path.row]
            }
            
            
            let ugTaskQuery = DesiUserGroupTask.query()
            ugTaskQuery!.includeKey("userGroup.group")
            ugTaskQuery!.whereKey("taskId", equalTo: aTaskView.theTask.objectId!)
            ugTaskQuery!.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        // The find succeeded.
                        print("Successfully retrieved \(objects!.count) ugTasks.")
                        // Do something with the found objects
                        if let objects = objects as? [PFObject] {
                            let ugTasks = objects as? [DesiUserGroupTask]
                            aTaskView.ugTasks = ugTasks
                            
                            //store found userGroups in Localstore
                            
                            aTaskView.tableView.reloadData()
                            
                        }
                    }
                    
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }

        }
        if (segue.identifier == "GoToGroupSettings"){
            let nav = segue.destinationViewController as! UINavigationController
            let settingsView = nav.topViewController as! GroupSettingsTableViewController
            settingsView.tasks = self.tasks
            settingsView.userGroup = self.userGroup
        }
        
    }


}
