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
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
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
        for userGroup in self.userGroupsForTask {
            self.membersLabel.text = self.membersLabel.text! + userGroup.user.firstName + " " + userGroup.user.lastName + ", "
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
    
    @IBAction func deleteTaskPressed(sender: UIButton){
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete the task?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let deleteHandler = { (action:UIAlertAction!) -> Void in
            self.performSegueWithIdentifier("deleteTaskSegue", sender: self)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: deleteHandler)
        alertController.addAction(deleteAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func backToTaskSettingsView(segue:UIStoryboardSegue){
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToTaskMembers" {
            let nav = segue.destinationViewController as! DesiNaviagtionController
            let members = nav.topViewController as! TaskMembersTableViewController
            members.outputUserGroups = self.userGroupsForTask
            let block = {
                (objects: [PFObject]?, error: NSError?) -> Void in
                guard error == nil else {
                    return
                }
                guard let userGroups = objects as? [DesiUserGroup] else {
                    return
                }
                members.userGroups = userGroups
                members.updateIsMember()
                print("here")
                members.tableView.reloadData()
                //members.refreshControl!.endRefreshing()
            }
            if self.userGroupsForGroup.count == 0 {
                getUserGroupsForGroup(self.myUgTask.userGroup.group, block: block)
            }
            
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
        
        if segue.identifier == "deleteTaskSegue" {
            let groupView = segue.destinationViewController as! GroupTableViewController
            groupView.refreshControl.beginRefreshing()
            let block = {
                (deleteSuccessful: Bool, error: NSError?) -> Void in
                guard error == nil else {
                    print(error)
                    groupView.refreshControl.endRefreshing()
                    return
                }
                
                guard deleteSuccessful else {
                    print("delete failed")
                    groupView.refreshControl.endRefreshing()
                    return
                }
                
                print("succesfully deleted task")
                groupView.userGroupTasks = groupView.userGroupTasks.filter({$0.task.objectId != self.task.objectId})
                groupView.filterUserGroupTasks()
                groupView.filterUserGroupTasksByTask()
                groupView.refreshControl.endRefreshing()
                groupView.tableView.reloadData()
            }
            
            self.task.deleteInBackgroundWithBlock(block)
        }
    }
 

}
