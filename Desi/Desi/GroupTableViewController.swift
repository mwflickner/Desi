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
    var userGroups = [DesiUserGroup]()
    
    var userGroupTasks = [DesiUserGroupTask]()
    
    var otherUserGroupTasks = [DesiUserGroupTask]()
    
    var myUserGroupTasks = [DesiUserGroupTask]()
    var myDesiTasks = [DesiUserGroupTask]()
    var myOtherTasks = [DesiUserGroupTask]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.myUserGroup.group.groupName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.userGroupTasks.count != 0 {
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
        if self.userGroupTasks.count != 0 {
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
            if isDesi {
                taskCell.groupNameLabel.text = self.myDesiTasks[indexPath.row].task.taskName
                taskCell.groupSumLabel.text = "You're up!"
            }
            else {
                taskCell.groupNameLabel.text = self.myOtherTasks[indexPath.row].task.taskName
                taskCell.groupSumLabel.text = "You are not the Desi"
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
    
    @IBAction func cancelToGroupVC(segue:UIStoryboardSegue){
        
    }
    
    @IBAction func createTaskPressed(sender: UIButton){
        sender.enabled = false
        
        let indexPath = NSIndexPath(forRow:0, inSection:0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! DesiTableViewCell
        let newTask = createNewTask(cell.textField.text!, pointValue: 1)
        print(newTask.taskName)
        let newUserGroupTasks = buildUserGroupTaskLinkedArray(self.userGroups, task: newTask)
        let block = ({
            (success: Bool, error: NSError?) -> Void in
            if success {
                print("new UserGroupsTask saved")
                cell.textField.text = ""
            }
            else {
                print("new UserGroupsTask error")
                cell.textField.text = ""
                setErrorColor(cell.textField)
                
            }
            sender.enabled = true
        })
        
        PFObject.saveAllInBackground(newUserGroupTasks, block: block)
        self.userGroupTasks.appendContentsOf(newUserGroupTasks)
        self.filterUserGroupTasks()
        self.tableView.reloadData()
    }
    
    func createNewTask(taskName: String, pointValue: Int) -> DesiTask {
        let newTask = DesiTask()
        newTask.taskName = taskName
        newTask.pointValue = pointValue
        return newTask
    }
    
    func createNewUserGroupTask(userGroup: DesiUserGroup, isDesi: Bool, task: DesiTask) -> DesiUserGroupTask {
        let newUserGroupTask = DesiUserGroupTask()
        newUserGroupTask.userGroup = userGroup
        newUserGroupTask.isDesi = isDesi
        newUserGroupTask.task = task
        return newUserGroupTask
    }
    
    func buildUserGroupTaskLinkedArray(userGroups: [DesiUserGroup], task: DesiTask) -> [DesiUserGroupTask] {
        var newUserGroupTasks = [DesiUserGroupTask]()
        let initialUgt = createNewUserGroupTask(self.myUserGroup, isDesi: true, task: task)
        var previousUgt = initialUgt
        newUserGroupTasks.append(previousUgt)
        for userGroup in self.userGroups {
            if userGroup.user != DesiUser.currentUser()! {
                let isDesi : Bool = (userGroup.user == DesiUser.currentUser()!)
                let newUgt = createNewUserGroupTask(userGroup, isDesi: isDesi, task: task)
                //newUgt.previous = previousUgt
                //previousUgt.nextUp = newUgt
                newUserGroupTasks.append(newUgt)
                //previousUgt = newUgt
            }
        }
        //initialUgt.previous = previousUgt
        //previousUgt.nextUp = initialUgt
        return newUserGroupTasks
    }
    
    func getUserGroupsForGroup(group: DesiGroup){
        let userGroupsQuery = DesiUserGroup.query()
        userGroupsQuery!.whereKey("group", equalTo: group)
        userGroupsQuery!.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                print("Successfully found \(objects!.count) userGroups")
                if let objects = objects as? [PFObject]{
                    if let userGroups = objects as? [DesiUserGroup]{
                        for userGroup in userGroups {
                            print(userGroup.isGroupAdmin)
                        }
                        self.userGroups = userGroups
                        
                        // save in to local store
                    }
                    else {
                        print("error")
                    }
                }
                else {
                    print("error shit")
                }
            }
            else {
                debugPrint(error)
            }
        }
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
        self.myDesiTasks = [DesiUserGroupTask]()
        self.myOtherTasks = [DesiUserGroupTask]()
        self.otherUserGroupTasks = [DesiUserGroupTask]()
        for ugTask in self.userGroupTasks {
            if ugTask.userGroup.user == DesiUser.currentUser()! {
                if ugTask.isDesi {
                    self.myDesiTasks.append(ugTask)
                }
                else {
                    self.myOtherTasks.append(ugTask)
                }
            }
            else {
                self.otherUserGroupTasks.append(ugTask)
            }
        }
    }
    
    func filterUserGroupTasksByTask(task: DesiTask) -> [DesiUserGroupTask] {
        var output = [DesiUserGroupTask]()
        for ugTask in self.userGroupTasks {
            if ugTask.task.objectId == task.objectId {
                output.append(ugTask)
            }
        }
        return output
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
                aTaskView.taskUserGroupTasks = self.filterUserGroupTasksByTask(self.myDesiTasks[path.row].task)
            }
            else if path.section == 2 {
                aTaskView.taskUserGroupTasks = self.filterUserGroupTasksByTask(self.myOtherTasks[path.row].task)
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
