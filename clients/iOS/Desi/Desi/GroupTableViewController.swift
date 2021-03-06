//
//  GroupTableViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 8/20/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse

class GroupTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var myUserGroup: DesiUserGroup!
    var userGroups = [String:DesiUserGroup]()
    
    var userGroupTasks = [DesiUserGroupTask]()
    
    var filteredUserGroupTasks = [Int: [DesiUserGroupTask]]() // [ relation to user : [The Desi UGTask]
    var taskFilteredUserGroupTasks = [String : [DesiUserGroupTask]]() // [ taskId : UGTask]
    
    var myUserGroupTasks = [Int: DesiUserGroupTask]()
    
    var groupLog = [DesiUserGroupLog]()
    var refreshControl = UIRefreshControl()
    var hasViewedLog: Bool = false
    
    var oldestLoadedLog: DesiUserGroupLog?
    var loadingMoreLogs: Bool = false
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    let myDesiUgTasksInt = 0
    let otherDesiUgTasksInt = 1
    let otherUgTasksInt = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.myUserGroup.group.groupName
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.activityIndicator.hidesWhenStopped = true
        self.tableView.tableFooterView = self.activityIndicator
        self.tableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self, action: #selector(getUserGroupTasksForGroup), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl.beginRefreshing()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.filteredUserGroupTasks[myDesiUgTasksInt] = []
        self.filteredUserGroupTasks[otherDesiUgTasksInt] = []
        self.filteredUserGroupTasks[otherUgTasksInt] = []
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.segControl.selectedSegmentIndex == 0 {
            if self.userGroupTasks.count != 0 {
                return 2
            }
            return 1
        }
        return self.groupLog.count
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if segControl.selectedSegmentIndex == 1 {
            if section < self.groupLog.count {
                return 10
            }
        }
        return 0
    }
    
    
    
    func tableView( tableView: UITableView,  titleForHeaderInSection section: Int) -> String? {
        if self.segControl.selectedSegmentIndex == 0 {
            switch(section) {
            case 0:  return "My Desi Tasks:"
            case 1: return "My Other Tasks:"
            case 2: return "Other Group Tasks:"
            default:  return nil
            }
        }
        if section == 0 {
            return "\(self.myUserGroup.group.groupName) Log"
        }
        return nil
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if segControl.selectedSegmentIndex == 0 {
            return 80
        }
        if indexPath.row == 0 {
            return 60
        }
        return 80
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if self.segControl.selectedSegmentIndex == 1 {
            if !loadingMoreLogs && indexPath.section == self.groupLog.count - 1 && self.groupLog.count >= 10 && self.tableView.tableFooterView != nil {
                print(self.loadingMoreLogs)
                self.activityIndicator.startAnimating()
                self.loadingMoreLogs = true
                self.getTaskLogForGroup()
            }
        }
        //self.tableView.tableFooterView = nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
        if indexPath.row == 0 {
            let logCell = tableView.dequeueReusableCellWithIdentifier("LogCell", forIndexPath: indexPath) as! DesiTableViewCell
            let logEntry = self.groupLog[indexPath.section]
            let firstName = logEntry.userGroup.user.firstName
            let lastName = logEntry.userGroup.user.lastName
            let verb = logEntry.actionTypeToVerb()!
            let cost = logEntry.points >= 0 ? "(+\(logEntry.points))" : "(\(logEntry.points))"
            let taskName = logEntry.task.taskName
            let time = dateToString(logEntry.createdAt!)
            logCell.label1.text = "\(firstName) \(lastName) \(verb) \(cost) \(taskName) on \(time)"
            logCell.separatorInset = UIEdgeInsetsMake(0.1, logCell.bounds.size.width, 0.1, 0.1)
            return logCell
        }
        let logMessageCell = tableView.dequeueReusableCellWithIdentifier("LogMessageCell", forIndexPath: indexPath) as! DesiTableViewCell
        let logEntry = self.groupLog[indexPath.section]
        logMessageCell.label2.text = logEntry.actionMessage
        return logMessageCell
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
            print(objects.count)
            if objects.count > 0 {
                guard let ugTasks = objects as? [DesiUserGroupTask] else {
                    return
                }
                self.userGroupTasks = ugTasks
                for ug in self.userGroupTasks {
                    print("User: \(ug.userGroup.user.username!)")
                }
                self.filterUserGroupTasks()
                self.filterUserGroupTasksByTask()
                
                //store found userGroups in Localstore
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
            let block = {
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
                print(objects.count)
                for userGroup in userGroups {
                    self.userGroups[userGroup.objectId!] = userGroup
                }
                self.refreshControl.endRefreshing()
            }
            getUserGroupsForGroup(self.myUserGroup.group, block: block)
            print(self.userGroups.count)
        }
    }
    
    func getTaskLogForGroup(){
        let group = self.myUserGroup.group
        let shouldLoadOldLogs = self.oldestLoadedLog != nil && self.loadingMoreLogs
        let userGroupQuery = DesiUserGroup.query()
        userGroupQuery?.whereKey("group", equalTo: group)
        
        let logQuery = DesiUserGroupLog.query()
        logQuery?.includeKey("userGroup")
        logQuery?.includeKey("task")
        logQuery?.includeKey("userGroup.user")
        logQuery?.whereKey("userGroup", matchesQuery: userGroupQuery!)
        if shouldLoadOldLogs {
            logQuery?.whereKey("createdAt", lessThan: (self.oldestLoadedLog?.createdAt)!)
        }
        logQuery?.addDescendingOrder("createdAt")
        logQuery?.limit = 10
        logQuery?.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            guard error == nil else {
                return
            }
            
            guard let logEntries = objects as? [DesiUserGroupLog] else {
                return
            }
            self.oldestLoadedLog = logEntries.last
            print(logEntries.count)
            if shouldLoadOldLogs {
                self.groupLog += logEntries
                self.loadingMoreLogs = false
                self.activityIndicator.stopAnimating()
                if logEntries.count == 0 {
                    self.tableView.tableFooterView = nil
                }
            }
            else {
                self.refreshControl.endRefreshing()
                self.groupLog = logEntries
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Filters
    
    func filterUserGroupTasks(){
        var myDesiUgTasks = [DesiUserGroupTask]()
        var otherDesiUgTasks = [DesiUserGroupTask]()
        var otherUgTasks = [DesiUserGroupTask]()

        for ugTask in self.userGroupTasks {
            self.userGroups[ugTask.userGroup.objectId!] = ugTask.userGroup
            if ugTask.isDesi {
                if ugTask.userGroup.user.objectId == DesiUser.currentUser()?.objectId {
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
            self.refreshControl.beginRefreshing()
            self.getTaskLogForGroup()
            self.hasViewedLog = true
        }
        if sender.selectedSegmentIndex == 1 {
            self.refreshControl.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
            self.refreshControl.addTarget(self, action: #selector(getTaskLogForGroup), forControlEvents: UIControlEvents.ValueChanged)
        }
        else {
            self.refreshControl.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
            self.refreshControl.addTarget(self, action: #selector(getUserGroupTasksForGroup), forControlEvents: UIControlEvents.ValueChanged)
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
            createView.userGroups = Array(self.userGroups.values)
        }
        
        if (segue.identifier == "goToGroupSettings"){
            let nav = segue.destinationViewController as! UINavigationController
            let settingsView = nav.topViewController as! GroupSettingsTableViewController
            //settingsView.tasks = self.tasks
            settingsView.myUserGroup = self.myUserGroup
            settingsView.userGroups = Array(self.userGroups.values)
        }
        
    }


}
