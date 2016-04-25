//
//  TaskSettingsTableViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 4/17/16.
//  Copyright © 2016 Desi. All rights reserved.
//

import UIKit
import Parse

class TaskSettingsTableViewController: UITableViewController {
    var userGroupsForGroup = [DesiUserGroup]()
    var userGroupsForTask = [DesiUserGroup]()
    var outputUserGroups = [DesiUserGroup]()
    var task = DesiTask()
    var userGroupTasks = [DesiUserGroupTask]()
    var myUgTask = DesiUserGroupTask()
    
    let defaultTaskName = "Untitled Task"
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var pointValueSlider: UISlider!
    @IBOutlet weak var repeatsSwitch: UISwitch!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        if !self.myUgTask.userGroup.isGroupAdmin {
            self.taskNameTextField.enabled = false
            self.pointValueSlider.enabled = false
            self.repeatsSwitch.enabled = false
            self.saveBarButton.enabled = false
        }
        self.outputUserGroups = userGroupsForTask
        self.taskNameTextField.text = task.taskName
        self.pointValueSlider.value = Float(task.pointValue)
        self.pointsLabel.text = String(task.pointValue)
        self.repeatsSwitch.on = task.repeats
        updateMembersLabel()
        
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
        if self.myUgTask.userGroup.isGroupAdmin {
            return 5
        }
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    func updateMembersLabel(){
        self.membersLabel.text = ""
        for userGroupTask in self.userGroupTasks {
            self.membersLabel.text = self.membersLabel.text! + userGroupTask.userGroup.user.firstName + " " + userGroupTask.userGroup.user.lastName + ", "
        }
        self.tableView.reloadData()
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let currentValue = Int(sender.value)
        //self.task.pointValue = currentValue
        self.pointsLabel.text = "\(currentValue)"
    }
    
    @IBAction func taskNameValueChanged(sender: UITextField){
        let name = sender.text
//        if let taskName = name {
//            self.task.taskName = taskName
//        }
//        else {
//            self.task.taskName = defaultTaskName
//        }
        print(self.task.taskName)
    }
    
    @IBAction func taskRepeatingToggled(sender: UISwitch){
        //self.task.repeats = sender.on
        print(sender.on)
    }
    
    @IBAction func backToTaskSettingsView(segue:UIStoryboardSegue){
        
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
        if segue.identifier == "goToTaskMembers" {
            let nav = segue.destinationViewController as! DesiNaviagtionController
            let members = nav.topViewController as! TaskMembersTableViewController
            members.outputUserGroups = self.outputUserGroups
//            let block = {
//                (objects: [PFObject]?, error: NSError?) -> Void in
//                guard error == nil else {
//                    return
//                }
//                guard let userGroups = objects as? [DesiUserGroup] else {
//                    return
//                }
//                members.userGroups = userGroups
//                members.updateIsMember()
//                print("here")
//                members.tableView.reloadData()
//                //members.refreshControl!.endRefreshing()
//            }
//            getUserGroupsForGroup(self.myUgTask.userGroup.group, block: block)
            //members.userGroups = self.userGroupsForGroup
            
            print("swag")
        }
        
        if segue.identifier == "saveTaskSettings" {
            let taskView = segue.destinationViewController as! TaskViewController
            taskView.task = self.task
            var taskChanged = false
            if self.task.repeats != self.repeatsSwitch.on {
                self.task.repeats = self.repeatsSwitch.on
                taskChanged = true
            }
            if self.task.taskName != self.taskNameTextField.text! {
                self.task.taskName = self.taskNameTextField.text! != "" ? self.taskNameTextField.text! : defaultTaskName
                taskChanged = true
            }
            if self.task.pointValue != Int(self.pointValueSlider.value) {
                self.task.pointValue = Int(self.pointValueSlider.value)
                taskChanged = true
            }
            
            if taskChanged {
                self.task.saveInBackgroundWithBlock{
                    (success: Bool, error: NSError?) -> Void in
                    if success {
                        print("new task saved")
                    }
                    else {
                        print("new task error")
                    }
                }
            }
        }
        
        if segue.identifier == "deleteTask" {
            let groupView = segue.destinationViewController as! GroupTableViewController
            groupView.userGroupTasks = groupView.userGroupTasks.filter({$0.task.objectId != self.task.objectId})
            groupView.filterUserGroupTasks()
            groupView.filterUserGroupTasksByTask()
            self.tableView.reloadData()
            deleteTask(self.task)
        }
    }
 

}
