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
    
    var filteredUserGroupTasks = [Int: [DesiUserGroupTask]]() // [ relation to user : [Int: The Desi UGTask]
    var taskFilteredUserGroupTasks = [String : [DesiUserGroupTask]]() // [ taskId : UGTask]
    
    var myUserGroupTasks = [Int: DesiUserGroupTask]()
    
    var groupLog = [DesiUserGroupTaskLog]()
    var hasViewedLog: Bool = false
    
    @IBOutlet weak var segControl: UISegmentedControl!
    
    let myDesiUgTasksInt = 0
    let otherDesiUgTasksInt = 1
    let otherUgTasksInt = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.tableView.addSubview(refreshControl!)
        self.refreshControl!.addTarget(self, action: #selector(getUserGroupTasksForGroup), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl?.beginRefreshing()
        self.filteredUserGroupTasks[myDesiUgTasksInt] = []
        self.filteredUserGroupTasks[otherDesiUgTasksInt] = []
        self.filteredUserGroupTasks[otherUgTasksInt] = []
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.segControl.selectedSegmentIndex == 0 {
            if self.userGroupTasks.count != 0 {
                return 3
            }
            return 1
        }
        return 1
        
    }
    
    override func tableView( tableView: UITableView,  titleForHeaderInSection section: Int) -> String {
        if self.segControl.selectedSegmentIndex == 0 {
            switch(section) {
            case 0:  return "My Desi Tasks"
            case 1: return "My Other Tasks"
            case 2: return "Other Group Tasks"
            default:  return ""
            }
        }
        return "\(self.myUserGroup.group.groupName) Log"
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segControl.selectedSegmentIndex == 0 {
            if self.userGroupTasks.count != 0 {
                switch(section){
                case 0: return self.filteredUserGroupTasks[myDesiUgTasksInt]!.count
                case 1: return self.filteredUserGroupTasks[otherDesiUgTasksInt]!.count
                case 2: return self.filteredUserGroupTasks[otherUgTasksInt]!.count
                default: return 0
                }
            }
            return 0
        }
        return self.groupLog.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if segControl.selectedSegmentIndex == 0 {
            return 80
        }
        return 120.0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.segControl.selectedSegmentIndex == 0 {
            let taskCell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as! DesiGroupsTableViewCell
            if indexPath.section == 0 {
                let myDesiUgTasks = self.filteredUserGroupTasks[myDesiUgTasksInt]
                let ugTask = myDesiUgTasks![indexPath.row]
                taskCell.groupNameLabel.text = ugTask.task.taskName
                taskCell.groupSumLabel.text = "You're up!"
                return taskCell
            }
            if indexPath.section == 1 {
                let otherDesiUgTasks = self.filteredUserGroupTasks[otherDesiUgTasksInt]
                let ugTask = otherDesiUgTasks![indexPath.row]
                taskCell.groupNameLabel.text = ugTask.task.taskName
                let firstName = ugTask.userGroup.user.firstName
                let lastName = ugTask.userGroup.user.lastName
                let desiName = "\(firstName) \(lastName)"
                taskCell.groupSumLabel.text = "\(desiName) is the Desi"
                return taskCell
            }
            if indexPath.section == 2 {
                let otherTasks = self.filteredUserGroupTasks[otherUgTasksInt]
                let ugTask = otherTasks![indexPath.row]
                taskCell.groupNameLabel.text = ugTask.task.taskName
                taskCell.groupSumLabel.text = "Someone else is the Desi"
                return taskCell
            }
            // this should never execute
            return taskCell
        }
        let logCell = tableView.dequeueReusableCellWithIdentifier("LogCell", forIndexPath: indexPath) as! DesiTableViewCell
        let logEntry = self.groupLog[indexPath.row]
        let firstName = logEntry.userGroupTask.userGroup.user.firstName
        let lastName = logEntry.userGroupTask.userGroup.user.lastName
        let verb = logEntry.actionTypeToVerb()
        let taskName = logEntry.userGroupTask.task.taskName
        logCell.label1.text = "\(firstName) \(lastName) \(verb) for \(taskName) at \(logEntry.createdAt!)"
        logCell.label2.text = logEntry.actionMessage
        return logCell
    }
    
    
    @IBAction func cancelToGroupVC(segue:UIStoryboardSegue){
        
    }

    // MARK: - Queries
    
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
            (objects: [PFObject]?, error: NSError?) -> Void in
            guard error == nil else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                return
            }
            
            // The find succeeded.
            print("Successfully retrieved \(objects!.count) ugTasks.")
            // Do something with the found objects
            guard let objects = objects else {
                return
            }
            if objects.count > 0 {
                guard let ugTasks = objects as? [DesiUserGroupTask] else {
                    return
                }
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
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
            else {
                self.getUserGroupsForGroup()
            }
            
        }
    }
    
    func getUserGroupsForGroup(){
        let userGroupQuery = DesiUserGroup.query()
        userGroupQuery!.includeKey("user")
        userGroupQuery!.includeKey("group")
        userGroupQuery!.whereKey("group", equalTo: self.myUserGroup.group)
        userGroupQuery!.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            guard error == nil else {
                return
            }
            guard let objects = objects else {
                return
            }
            guard let userGroups = objects as? [DesiUserGroup] else {
                return
            }
            self.userGroups = Set(userGroups)
            self.refreshControl?.endRefreshing()

        }
    }
    
    func getTaskLogForGroup(){
        let group = self.myUserGroup.group
        let userGroupQuery = DesiUserGroup.query()
        userGroupQuery?.whereKey("group", equalTo: group)
        
        let userGroupTaskQuery = DesiUserGroupTask.query()
        userGroupTaskQuery?.whereKey("userGroup", matchesQuery: userGroupQuery!)
        
        let logQuery = DesiUserGroupTaskLog.query()
        logQuery?.includeKey("userGroupTask")
        logQuery?.includeKey("userGroupTask.userGroup")
        logQuery?.includeKey("userGroupTask.task")
        logQuery?.includeKey("userGroupTask.userGroup.user")
        logQuery?.whereKey("userGroupTask", matchesQuery: userGroupTaskQuery!)
        logQuery?.addDescendingOrder("createdAt")
        logQuery?.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            guard error == nil else {
                return
            }
            
            guard let logEntries = objects as? [DesiUserGroupTaskLog] else {
                return
            }
            
            self.groupLog = logEntries
            self.refreshControl?.endRefreshing()
            if self.segControl.selectedSegmentIndex == 1 {
                self.tableView.reloadData()
            }
            print(logEntries.count)
        }
    }
    
    // MARK: - Filters
    
    func filterUserGroupTasks(){
        var myDesiUgTasks = [DesiUserGroupTask]()
        var otherDesiUgTasks = [DesiUserGroupTask]()
        var otherUgTasks = [DesiUserGroupTask]()

        for ugTask in self.userGroupTasks {
            self.userGroups.insert(ugTask.userGroup)
            if ugTask.isDesi {
                if ugTask.userGroup.user == DesiUser.currentUser() {
                    myDesiUgTasks.append(ugTask)
                }
                else {
                    otherDesiUgTasks.append(ugTask)
                }
            }
            else {
                otherUgTasks.append(ugTask)
            }
        }
        
        self.filteredUserGroupTasks[myDesiUgTasksInt] = myDesiUgTasks
        self.filteredUserGroupTasks[otherDesiUgTasksInt] = otherDesiUgTasks
        self.filteredUserGroupTasks[otherUgTasksInt] = otherUgTasks
    }
    
    
    func filterUserGroupTasksByTask(){
        for ugTask in self.userGroupTasks {
            var ugTaskHash = self.taskFilteredUserGroupTasks[ugTask.task.objectId!]
            if ugTaskHash != nil {
                ugTaskHash!.append(ugTask)
                self.taskFilteredUserGroupTasks[ugTask.task.objectId!] = ugTaskHash
            }
            else {
                var newUgTask = [DesiUserGroupTask]()
                newUgTask.append(ugTask)
                self.taskFilteredUserGroupTasks[ugTask.task.objectId!] = newUgTask
            }
        }
    }
    
    @IBAction func segControlChanged(sender: UISegmentedControl){
        sender.enabled = false
        if !hasViewedLog {
            self.refreshControl!.beginRefreshing()
            self.getTaskLogForGroup()
            self.hasViewedLog = true
        }
        if sender.selectedSegmentIndex == 1 {
            self.refreshControl!.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
            self.refreshControl!.addTarget(self, action: #selector(getTaskLogForGroup), forControlEvents: UIControlEvents.ValueChanged)
        }
        else {
            self.refreshControl!.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
            self.refreshControl!.addTarget(self, action: #selector(getUserGroupTasksForGroup), forControlEvents: UIControlEvents.ValueChanged)
        }
        self.tableView.reloadData()
        sender.enabled = true
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "loadTask" {
            if self.taskFilteredUserGroupTasks.count == 0 {
                self.filterUserGroupTasksByTask()
            }
            let path = self.tableView.indexPathForSelectedRow!
            let nav = segue.destinationViewController as! UINavigationController
            let aTaskView = nav.topViewController as! TaskViewController
            aTaskView.userGroup = self.myUserGroup
            
            if path.section == 0 {
                let task = self.filteredUserGroupTasks[myDesiUgTasksInt]![path.row].task
                aTaskView.taskUserGroupTasks = self.taskFilteredUserGroupTasks[task.objectId!]!
                aTaskView.task = task
            }
            else if path.section == 1 {
                let task = self.filteredUserGroupTasks[otherDesiUgTasksInt]![path.row].task
                aTaskView.taskUserGroupTasks = self.taskFilteredUserGroupTasks[task.objectId!]!
                aTaskView.task = task
            }
            else if path.section == 2 {
                let task = self.filteredUserGroupTasks[otherUgTasksInt]![path.row].task
                aTaskView.taskUserGroupTasks = self.taskFilteredUserGroupTasks[task.objectId!]!
                aTaskView.task = task
            }
            aTaskView.getUserGroupTasksForTask()
        }
        
        if (segue.identifier == "goToCreateTask"){
            let nav = segue.destinationViewController as! UINavigationController
            let createView = nav.topViewController as! CreateTaskTableViewController
            createView.userGroups = Array(self.userGroups)
        }
        
        if (segue.identifier == "GoToGroupSettings"){
            let nav = segue.destinationViewController as! UINavigationController
            let settingsView = nav.topViewController as! GroupSettingsTableViewController
            //settingsView.tasks = self.tasks
            settingsView.userGroup = self.myUserGroup
        }
        
    }


}
