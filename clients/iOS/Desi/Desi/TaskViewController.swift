//
//  TheGroupTableViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 6/18/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userGroup: DesiUserGroup!
    var taskUserGroupTasks = [DesiUserGroupTask]()
    var taskLog = [DesiUserGroupLog]()
    var newLogEntries = [DesiUserGroupLog]()
    
    var myUgTask: DesiUserGroupTask?
    var desiUgTasks = [DesiUserGroupTask]()
    var task: DesiTask!
    
    var refreshControl = UIRefreshControl()
    
    var hasViewedLog: Bool = false
    var oldestLoadedLog: DesiUserGroupLog?
    var loadingMoreLogs: Bool = false
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segControl : UISegmentedControl!
    @IBOutlet weak var goToCompleteButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.activityIndicator.hidesWhenStopped = true
        self.tableView.tableFooterView = self.activityIndicator
        self.tableView.addSubview(self.refreshControl)
        self.refreshControl.addTarget(self, action: #selector(getUserGroupTasksForTask), forControlEvents: .ValueChanged)
        self.refreshControl.beginRefreshing()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = task.taskName
        self.updateTaskData()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch self.segControl.selectedSegmentIndex {
            case 0:  return 3
            case 1:  return self.taskLog.count
            default:  return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.segControl.selectedSegmentIndex == 0 {
            if section == 0 {
                return "The Desi:"
            }
            if section == 1 {
                return "On Deck:"
            }
        }
        return nil
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segControl.selectedSegmentIndex == 0 {
            if section == 0 {
                return self.task.numberOfDesis
            }
            if section == 1 {
                if self.taskUserGroupTasks.count < 2*self.task.numberOfDesis {
                    return self.taskUserGroupTasks.count - self.task.numberOfDesis
                }
                return self.task.numberOfDesis
            }
            let x = self.taskUserGroupTasks.count - 2*self.task.numberOfDesis
            if x > 0 {
                return x
            }
            return 0
        }
        return 2
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if segControl.selectedSegmentIndex == 1 {
            if section < self.taskLog.count {
                return 10
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if segControl.selectedSegmentIndex == 0 {
            if indexPath.section == 1 {
                return 80
            }
            else {
                return 60
            }
        }
        if indexPath.row == 0 {
            return 60
        }
        return 80
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if self.segControl.selectedSegmentIndex == 1 {
            if !loadingMoreLogs && indexPath.section == self.taskLog.count - 1 && self.taskLog.count >= 10 && self.tableView.tableFooterView != nil {
                print(self.loadingMoreLogs)
                self.activityIndicator.startAnimating()
                self.loadingMoreLogs = true
                self.getTaskLog()
            }
        }
        //self.tableView.tableFooterView = nil
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if self.segControl.selectedSegmentIndex == 1 {
//            if self.taskLog[indexPath.section].userGroup.user.objectId == DesiUser.currentUser()?.objectId || self.userGroup.isGroupAdmin {
//                let alertController = UIAlertController(title: nil, message: "Log Actions:", preferredStyle: .ActionSheet)
//                
//                let cancelHander = { (action:UIAlertAction!) -> Void in
//                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
//                }
//                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelHander)
//                alertController.addAction(cancelAction)
//                
//                let undoActionHandler = { (action:UIAlertAction!) -> Void in
//                    print("undoing")
//                }
//                let logoutAction = UIAlertAction(title: "Undo Action", style: .Destructive, handler: undoActionHandler)
//                alertController.addAction(logoutAction)
//                
//                presentViewController(alertController, animated: true, completion: nil)
//            }
//            else {
//                tableView.deselectRowAtIndexPath(indexPath, animated: true)
//            }
//        }
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if segControl.selectedSegmentIndex == 0 {
            if indexPath.section == 0 {
                let desiCell = tableView.dequeueReusableCellWithIdentifier("TheDesiCell", forIndexPath: indexPath) as! DesiTableViewCell
                let ugTask = self.taskUserGroupTasks[indexPath.row]
                let firstName = ugTask.userGroup.user.firstName
                let lastName = ugTask.userGroup.user.lastName
                let points = ugTask.userGroup.points
                desiCell.label1.text = "\(firstName) \(lastName)"
                desiCell.label2.text = String(points)
                return desiCell
            }
            if indexPath.section == 1 {
                let onDeckCell = tableView.dequeueReusableCellWithIdentifier("OnDeckCell", forIndexPath: indexPath) as! DesiTableViewCell
                let ugTask = self.taskUserGroupTasks[((indexPath.row + self.task.numberOfDesis) % self.taskUserGroupTasks.count)]
                let firstName = ugTask.userGroup.user.firstName
                let lastName = ugTask.userGroup.user.lastName
                onDeckCell.label1.text = "\(firstName) \(lastName)"
                let points = ugTask.userGroup.points
                onDeckCell.label2.text = String(points)
                return onDeckCell
            }
            let restCell = tableView.dequeueReusableCellWithIdentifier("RestOfGroupCell", forIndexPath: indexPath) as! DesiTableViewCell
            let ugTask = self.taskUserGroupTasks[((indexPath.row + 2*self.task.numberOfDesis) % self.taskUserGroupTasks.count)]
            let firstName = ugTask.userGroup.user.firstName
            let lastName = ugTask.userGroup.user.lastName
            restCell.label1.text = "\(firstName) \(lastName)"
            let points = ugTask.userGroup.points
            restCell.label2.text = String(points)
            return restCell
        }
        if indexPath.row == 0 {
            let logCell = tableView.dequeueReusableCellWithIdentifier("LogCell", forIndexPath: indexPath) as! DesiTableViewCell
            let logEntry = self.taskLog[indexPath.section]
            let firstName = logEntry.userGroup.user.firstName
            let lastName = logEntry.userGroup.user.lastName
            let verb = logEntry.actionTypeToVerb()!
            let cost = logEntry.points >= 0 ? "+\(logEntry.points)" : "\(logEntry.points)"
            let date = dateToString(logEntry.createdAt!)
            logCell.label1.text = "\(firstName) \(lastName) \(verb) (\(cost)) on \(date)"
            logCell.separatorInset = UIEdgeInsetsMake(0.1, logCell.bounds.size.width, 0.1, 0.1)
            return logCell

        }
        let logMessageCell = tableView.dequeueReusableCellWithIdentifier("LogMessageCell", forIndexPath: indexPath) as! DesiTableViewCell
        let logEntry = self.taskLog[indexPath.section]
        logMessageCell.label2.text = logEntry.actionMessage
        return logMessageCell
    }
    
    func updateTaskData(){
        self.taskUserGroupTasks.sortInPlace({ $0.queueSpot < $1.queueSpot })
        self.desiUgTasks = []
        for ugTask in taskUserGroupTasks {
            if ugTask.isDesi {
                desiUgTasks.append(ugTask)
            }
            if ugTask.userGroup.user.objectId == DesiUser.currentUser()?.objectId {
                self.myUgTask = ugTask
            }
        }
        self.tableView.reloadData()
        self.updateActionButton()
    }
    
    func updateActionButton(){
        if self.myUgTask != nil {
            self.goToCompleteButton.enabled = true
        }
        else {
            self.goToCompleteButton.enabled = false
        }
    }
    
    func completeTask(message: String){
        let oldDesiUGTasks = self.desiUgTasks
        self.newLogEntries = []
        for oldDesi in oldDesiUGTasks {
            let taskPoints = self.task.pointValue
            print(taskPoints)
            oldDesi.userGroup.points += taskPoints
            print(oldDesi.userGroup.points)
            let logEntry = DesiUserGroupLog()
            logEntry.userGroup = oldDesi.userGroup
            logEntry.actionMessage = message
            logEntry.actionType = "completion"
            logEntry.points = taskPoints
            logEntry.task = self.task
            self.taskLog.append(logEntry)
            self.newLogEntries.append(logEntry)
        }
        if self.task.repeats {
            if self.taskUserGroupTasks.count > 1 {
                self.desiUgTasks = []
                let range: Range<Int> = 0..<self.task.numberOfDesis
                self.taskUserGroupTasks.removeRange(range)
                self.taskUserGroupTasks = self.taskUserGroupTasks + oldDesiUGTasks
                for (index,ugTask) in self.taskUserGroupTasks.enumerate() {
                    ugTask.queueSpot = index
                    if index < self.task.numberOfDesis {
                        ugTask.isDesi = true
                        desiUgTasks.append(ugTask)
                    }
                    else {
                        ugTask.isDesi = false
                    }
                }
            }
        }
        self.saveTaskState(false)
        
    }
    
    func volunteerCompleteTask(message: String){
        self.taskUserGroupTasks = self.taskUserGroupTasks.filter({$0.objectId != myUgTask?.objectId})
        let count = self.taskUserGroupTasks.count
        self.myUgTask?.queueSpot = count
        self.myUgTask?.userGroup.points += 2*self.task.pointValue
        self.taskUserGroupTasks.append(self.myUgTask!)
        for (index, ugTask) in self.taskUserGroupTasks.enumerate() {
            ugTask.queueSpot = index
        }
        self.newLogEntries = []
        let logEntry = DesiUserGroupLog()
        logEntry.userGroup = (self.myUgTask?.userGroup)!
        logEntry.actionMessage = message
        logEntry.actionType = "volunteer"
        logEntry.task = self.task
        logEntry.points = 2*self.task.pointValue
        self.taskLog.append(logEntry)
        self.newLogEntries.append(logEntry)
        self.saveTaskState(false)
    }
    
    func optOutOfTask(message: String){
        self.desiUgTasks = []
        if let myUgTask = self.myUgTask {
            myUgTask.isDesi = false
            myUgTask.userGroup.points -= self.task.optOutCost
            print(self.task.optOutCost)
            print(myUgTask.userGroup.points)
            self.taskUserGroupTasks = self.taskUserGroupTasks.filter({$0.objectId != myUgTask.objectId})
            myUgTask.queueSpot = self.taskUserGroupTasks.count
            self.taskUserGroupTasks.append(myUgTask)
            self.myUgTask = myUgTask
            
            for (index, ugTask) in self.taskUserGroupTasks.enumerate() {
                ugTask.queueSpot = index
                if index < ugTask.task.numberOfDesis {
                    ugTask.isDesi = true
                    desiUgTasks.append(ugTask)
                }
            }
            self.newLogEntries = []
            let logEntry = DesiUserGroupLog()
            logEntry.userGroup = (self.myUgTask?.userGroup)!
            logEntry.actionMessage = message
            logEntry.actionType = "opt-out"
            logEntry.task = self.task
            logEntry.points = -self.task.optOutCost
            self.taskLog.append(logEntry)
            self.newLogEntries.append(logEntry)
            self.saveTaskState(true)
        }
        else {
            // exception
        }
    }
    
    // MARK: - Queries
    
    func getUserGroupTasksForTask(){
        let task = self.task
        let query = DesiUserGroupTask.query()
        query?.includeKey("task")
        query?.includeKey("userGroup")
        query?.includeKey("userGroup.user")
        query?.includeKey("userGroup.group")
        query?.whereKey("task", equalTo: task)
        query?.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            guard error == nil else {
                return
            }
            guard let userGroupTasks = objects as? [DesiUserGroupTask] else {
                return
            }
            for ugtTask in userGroupTasks {
                print("UGT userName: \(ugtTask.userGroup.user.username)")
            }
            self.taskUserGroupTasks = userGroupTasks
            self.refreshControl.endRefreshing()
            self.updateTaskData()
        }
    }
    
    func getTaskLog(){
        print(self.oldestLoadedLog)
        let shouldLoadOldLogs = (self.oldestLoadedLog != nil) && self.loadingMoreLogs
        let userGroupQuery = DesiUserGroup.query()
        userGroupQuery?.whereKey("group", equalTo: self.userGroup.group)
        
        let logQuery = DesiUserGroupLog.query()
        logQuery?.includeKey("userGroup")
        logQuery?.includeKey("task")
        logQuery?.includeKey("userGroup.user")
        logQuery?.whereKey("userGroup", matchesQuery: userGroupQuery!)
        logQuery?.whereKey("task", equalTo: self.task)
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
                self.taskLog += logEntries
                self.loadingMoreLogs = false
                self.activityIndicator.stopAnimating()
                print("stoppls")
                if logEntries.count == 0 {
                    self.tableView.tableFooterView = nil
                }
            }
            else {
                self.refreshControl.endRefreshing()
                self.taskLog = logEntries
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Saves
    
    func saveTaskState(isOptOut: Bool){
        print("saving Task state")
        let ugtTasks : [PFObject] = self.taskUserGroupTasks
        let newLogs: [PFObject] = self.newLogEntries
        let taskState: [PFObject] = ugtTasks + newLogs
        let block = {
            (success: Bool, error: NSError?) -> Void in
            guard success else {
                print("task state save error")
                return
            }
            if !self.task.repeats && !isOptOut {
                self.performSegueWithIdentifier("deleteOneTimeTaskSegue", sender: self)
            }
        }
        PFObject.saveAllInBackground(taskState, block: block)
    }
    
    // MARK: - IBActions
    
    @IBAction func segControlChanged(sender: UISegmentedControl){
        sender.enabled = false
        if !hasViewedLog {
            self.getTaskLog()
            self.hasViewedLog = true
        }
        if sender.selectedSegmentIndex == 1 {
            self.refreshControl.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
            self.refreshControl.addTarget(self, action: #selector(getTaskLog), forControlEvents: UIControlEvents.ValueChanged)
        }
        else {
            self.refreshControl.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
            self.refreshControl.addTarget(self, action: #selector(getUserGroupTasksForTask), forControlEvents: UIControlEvents.ValueChanged)
        }
        self.tableView.reloadData()
        sender.enabled = true
       
    }
    
    
    @IBAction func cancelToTaskView(segue:UIStoryboardSegue) {
        
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToCompletionForm" {
            let nav = segue.destinationViewController as! DesiNaviagtionController
            let completion = nav.topViewController as! TaskActionTableViewController
            if let myUgTask = self.myUgTask {
                completion.myUgtTask = myUgTask
            }
        }
        
        if segue.identifier == "goToTaskSettings" {
            let nav = segue.destinationViewController as! DesiNaviagtionController
            let settings = nav.topViewController as! TaskSettingsTableViewController
            settings.userGroupTasks = self.taskUserGroupTasks
            var userGroupsForTask = [DesiUserGroup]()
            for ugt in self.taskUserGroupTasks {
                userGroupsForTask.append(ugt.userGroup)
            }
            settings.userGroupsForTask = userGroupsForTask
            settings.task = self.task
            settings.myUgTask = self.myUgTask!
        }
        
        if segue.identifier == "backToGroup" {
            let group = segue.destinationViewController as! GroupTableViewController
            group.refreshControl.beginRefreshing()
            group.getUserGroupTasksForGroup()
        }
        
        if segue.identifier == "deleteOneTimeTaskSegue" {
            let groupView = segue.destinationViewController as! GroupTableViewController
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
