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
    
    var myUserGroup: DesiUserGroup!
    var userGroups = Set<DesiUserGroup>()
    
    var userGroupTasks = [DesiUserGroupTask]()
    
    var filteredUserGroupTasks = [Int: [Int: DesiUserGroupTask]]() // [ relation to user : [Int: UGTask]
    var taskFilteredUserGroupTasks = [String : [Int: DesiUserGroupTask]]() // [ taskId : Arrary or Set of UGTs ]
    
    var myUserGroupTasks = [Int: DesiUserGroupTask]()
    
    
    
    let myDesiTasksInt = 0
    let myOtherTasksInt = 1
    let otherTasksInt = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.myUserGroup.group.groupName
        self.filteredUserGroupTasks[myDesiTasksInt] = [:]
        self.filteredUserGroupTasks[myOtherTasksInt] = [:]
        self.filteredUserGroupTasks[otherTasksInt] = [:]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.userGroupTasks.count != 0 {
            return 4
        }
        return 1
    }
    
    override func tableView( tableView: UITableView,  titleForHeaderInSection section: Int) -> String {
        switch(section) {
            case 0: return "New Task"
            case 1:  return "My Desi Tasks"
            case 2: return "My Other Tasks"
            case 3: return "Other Group Tasks"
            default:  return ""
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.userGroupTasks.count != 0 {
            switch(section){
                case 0: return 1
                case 1: return self.filteredUserGroupTasks[myDesiTasksInt]!.count
                case 2: return self.filteredUserGroupTasks[myOtherTasksInt]!.count
                case 3: return self.filteredUserGroupTasks[otherTasksInt]!.count
                default: return 0
            }
        }
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        func setUpTaskCell(isDesi: Bool) -> DesiGroupsTableViewCell {
            let taskCell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as! DesiGroupsTableViewCell
            if indexPath.section == 1 {
                taskCell.groupNameLabel.text = self.filteredUserGroupTasks[myDesiTasksInt]![indexPath.row]!.task.taskName
                taskCell.groupSumLabel.text = "You're up!"
            }
            else if indexPath.section == 2 {
                let myOtherTasks = self.filteredUserGroupTasks[myOtherTasksInt]
                if myOtherTasks?.count > 0 {
                    taskCell.groupNameLabel.text = myOtherTasks![indexPath.row]!.task.taskName
                    taskCell.groupSumLabel.text = "You are not the Desi"
                }
            }
            else if indexPath.section == 3 {
                let otherTasks = self.filteredUserGroupTasks[otherTasksInt]
                if otherTasks?.count > 0 {
                    taskCell.groupNameLabel.text = otherTasks![indexPath.row]!.task.taskName
                    taskCell.groupSumLabel.text = "Someone else is the Desi"
                }
            }
            return taskCell
        }
        
        func setUpCreateTaskCell() -> DesiTableViewCell {
            let createTaskCell = tableView.dequeueReusableCellWithIdentifier("createTaskCell", forIndexPath: indexPath) as! DesiTableViewCell
            createTaskCell.button.setTitle("Create!", forState: UIControlState.Normal)
            createTaskCell.button.addTarget(self, action: "createTaskPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            return createTaskCell
        }
        
        if self.userGroupTasks.count != 0 {
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
        return setUpCreateTaskCell()

    }
    
    @IBAction func cancelToGroupVC(segue:UIStoryboardSegue){
        
    }
    
    @IBAction func createTaskPressed(sender: UIButton){
        sender.enabled = false
        
        let indexPath = NSIndexPath(forRow:0, inSection:0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! DesiTableViewCell
        let newTask = createNewTask(cell.textField.text!, numberOfDesis: 1, pointValue: 1)
        print(newTask.taskName)
        let newUserGroupTasks = buildUserGroupTasks(self.userGroups, task: newTask)
        let block = ({
            (success: Bool, error: NSError?) -> Void in
            if success {
                print("new UserGroupsTask saved")
                cell.textField.text = ""
                self.userGroupTasks.appendContentsOf(newUserGroupTasks)
                self.filterUserGroupTasks()
                self.tableView.reloadData()
            }
            else {
                print("new UserGroupsTask error")
                cell.textField.text = ""
                setErrorColor(cell.textField)
                
            }
            sender.enabled = true
        })
        
        PFObject.saveAllInBackground(newUserGroupTasks, block: block)
    }
    
    func createNewTask(taskName: String, numberOfDesis: Int, pointValue: Int) -> DesiTask {
        let newTask = DesiTask()
        newTask.taskName = taskName
        newTask.numberOfDesis = numberOfDesis
        newTask.pointValue = pointValue
        return newTask
    }
    
    func createNewUserGroupTask(userGroup: DesiUserGroup, queueSpot: Int, task: DesiTask) -> DesiUserGroupTask {
        let newUserGroupTask = DesiUserGroupTask()
        newUserGroupTask.userGroup = userGroup
        newUserGroupTask.task = task
        newUserGroupTask.queueSpot = queueSpot
        newUserGroupTask.isDesi = queueSpot <= task.numberOfDesis
        return newUserGroupTask
    }
    
    func buildUserGroupTasks(userGroups: NSSet, task: DesiTask) -> [DesiUserGroupTask] {
        var newUserGroupTasks = [DesiUserGroupTask]()
        for (index,userGroup) in self.userGroups.enumerate() {
            if let ug = userGroup as? DesiUserGroup {
                let newUgt = createNewUserGroupTask(ug, queueSpot: index, task: task)
                newUserGroupTasks.append(newUgt)
            }
            
        }
        return newUserGroupTasks
    }
    
    func getUserGroupTasksForGroup(){
        
        let userGroupQuery = DesiUserGroup.query()
        userGroupQuery!.whereKey("group", equalTo: self.myUserGroup.group)
        
        let ugTaskQuery = DesiUserGroupTask.query()
        ugTaskQuery!.includeKey("userGroup")
        ugTaskQuery!.includeKey("userGroup.user")
        ugTaskQuery!.includeKey("userGroup.group")
        ugTaskQuery!.includeKey("task")
        ugTaskQuery!.whereKey("userGroup", matchesQuery: userGroupQuery!)
        ugTaskQuery!.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) ugTasks.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    if let ugTasks = objects as? [DesiUserGroupTask] {
                        self.userGroupTasks = ugTasks
                        for ug in self.userGroupTasks {
                            print("User: \(ug.userGroup.user.username!)")
                            print("Group: \(ug.userGroup.group.groupName)")
                            print("Task: \(ug.task.taskName)")
                            print("isDesi: \(ug.isDesi) \n")
                        }
                        self.filterUserGroupTasks()
                        self.filterUserGroupTasksByTask()
                        //store found userGroups in Localstore
                        self.tableView.reloadData()
                    }
                }
            }
            else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }

    }
    
    func filterUserGroupTasks(){
        var myDesiTasks = [Int: DesiUserGroupTask]()
        var myOtherTasks = [Int: DesiUserGroupTask]()
        var otherUserGroupTasks = [Int: DesiUserGroupTask]()

        for ugTask in self.userGroupTasks {
            self.userGroups.insert(ugTask.userGroup)
            if ugTask.userGroup.user == DesiUser.currentUser()! {
                if ugTask.isDesi {
                    myDesiTasks[myDesiTasks.count] = ugTask
                    self.filteredUserGroupTasks[myDesiTasksInt] = myDesiTasks
                }
                else {
                    myOtherTasks[myOtherTasks.count] = ugTask
                    self.filteredUserGroupTasks[myOtherTasksInt] = myOtherTasks
                }
            }
            else {
                otherUserGroupTasks[myOtherTasks.count] = ugTask
                self.filteredUserGroupTasks[otherTasksInt] = otherUserGroupTasks
                
            }
            
            print("UserGroups: \(self.userGroups) \n \n")
            print("myDesiTasks Hash: \(myDesiTasks) \n \n")
            print("myOtherTasks Hash: \(myOtherTasks) \n \n")
            print("otherTasks meh: \(otherUserGroupTasks) \n \n")
            print("hashSwag: \(self.filteredUserGroupTasks[myDesiTasksInt]) \n \n")
            
        }
    }
    
    func filterUserGroupTasksByTask(){
        for ugTask in self.userGroupTasks {
            var ugTaskHash = self.taskFilteredUserGroupTasks[ugTask.task.objectId!]
            if ugTaskHash != nil {
                ugTaskHash![ugTaskHash!.count] = ugTask
                self.taskFilteredUserGroupTasks[ugTask.task.objectId!] = ugTaskHash
            }
            else {
                var newTaskHash = [Int: DesiUserGroupTask]()
                newTaskHash[newTaskHash.count] = ugTask
                self.taskFilteredUserGroupTasks[ugTask.task.objectId!] = newTaskHash
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
            let aTaskView = nav.topViewController as! TaskViewController
            aTaskView.userGroup = self.myUserGroup
            
            if path.section == 1 {
                let task = self.filteredUserGroupTasks[myDesiTasksInt]![path.row]!.task
                aTaskView.taskUserGroupTasks = self.taskFilteredUserGroupTasks[task.objectId!]!
                aTaskView.task = task
            }
            else if path.section == 2 {
                let task = self.filteredUserGroupTasks[myOtherTasksInt]![path.row]!.task
                aTaskView.taskUserGroupTasks = self.taskFilteredUserGroupTasks[task.objectId!]!
                aTaskView.task = task
            }
            else if path.section == 3 {
                let task = self.filteredUserGroupTasks[otherTasksInt]![path.row]!.task
                aTaskView.taskUserGroupTasks = self.taskFilteredUserGroupTasks[task.objectId!]!
                aTaskView.task = task
            }
        }
        
        if (segue.identifier == "GoToGroupSettings"){
            let nav = segue.destinationViewController as! UINavigationController
            let settingsView = nav.topViewController as! GroupSettingsTableViewController
            //settingsView.tasks = self.tasks
            settingsView.userGroup = self.myUserGroup
        }
        
    }


}
