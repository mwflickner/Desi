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
    var taskLog = [DesiUserGroupTaskLog]()
    var newLogEntries = [DesiUserGroupTaskLog]()
    
    var myUgTask: DesiUserGroupTask?
    var desiUgTasks = [DesiUserGroupTask]()
    var task: DesiTask!
    
    var refreshControl = UIRefreshControl()
    
    var hasViewedLog: Bool = false
    var oldestLoadedLog: DesiUserGroupTaskLog?
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
        //tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 120.0
        self.navigationItem.title = task.taskName
        self.updateTaskData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch self.segControl.selectedSegmentIndex {
            case 0:  return 3
            case 1:  return 1
            default:  return 0
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segControl.selectedSegmentIndex == 0 {
            if section == 0 {
                return self.task.numberOfDesis
            }
            if section == 1 {
                return self.task.numberOfDesis
            }
            let x = self.taskUserGroupTasks.count - 2*self.task.numberOfDesis
            if x > 0 {
                return x
            }
            return 0
        }
        return self.taskLog.count
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
        return 120
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if self.segControl.selectedSegmentIndex == 1 {
            if !loadingMoreLogs && indexPath.row == self.taskLog.count - 1 && self.taskLog.count >= 10 && self.tableView.tableFooterView != nil {
                print(self.loadingMoreLogs)
                self.activityIndicator.startAnimating()
                self.loadingMoreLogs = true
                self.getTaskLog()
            }
        }
        //self.tableView.tableFooterView = nil
    }
    
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
        let logCell = tableView.dequeueReusableCellWithIdentifier("LogCell", forIndexPath: indexPath) as! DesiTableViewCell
        let logEntry = self.taskLog[indexPath.row]
        let firstName = logEntry.userGroupTask.userGroup.user.firstName
        let lastName = logEntry.userGroupTask.userGroup.user.lastName
        let verb = logEntry.actionTypeToVerb()
        
        logCell.label1.text = "\(firstName) \(lastName) \(verb) at \(logEntry.createdAt!)"
        logCell.label2.text = logEntry.actionMessage
        return logCell
    }
    
    func updateTaskData(){
        self.taskUserGroupTasks.sortInPlace({ $0.queueSpot < $1.queueSpot })
        for ugTask in taskUserGroupTasks {
            if ugTask.isDesi {
                desiUgTasks.append(ugTask)
            }
            if ugTask.userGroup.user == DesiUser.currentUser() {
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
            oldDesi.userGroup.points += taskPoints
            let logEntry = DesiUserGroupTaskLog()
            logEntry.userGroupTask = oldDesi
            logEntry.actionMessage = message
            logEntry.actionType = "completion"
            self.taskLog.append(logEntry)
            self.newLogEntries.append(logEntry)
            //oldDesi.userGroup.user.desiScore += taskPoints
        }
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
        self.saveTaskState()
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
        let logEntry = DesiUserGroupTaskLog()
        logEntry.userGroupTask = self.myUgTask!
        logEntry.actionMessage = message
        logEntry.actionType = "volunteer"
        self.taskLog.append(logEntry)
        self.newLogEntries.append(logEntry)
        self.saveTaskState()
    }
    
    func optOutOfTask(message: String){
        self.desiUgTasks = []
        if let myUgTask = self.myUgTask {
            myUgTask.isDesi = false
            myUgTask.userGroup.points -= self.task.optOutCost
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
            let logEntry = DesiUserGroupTaskLog()
            logEntry.userGroupTask = self.myUgTask!
            logEntry.actionMessage = message
            logEntry.actionType = "opt-out"
            self.taskLog.append(logEntry)
            self.newLogEntries.append(logEntry)
            self.saveTaskState()
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
                print("Task ID: \(ugtTask.task.objectId)")
                print("UGT TaskID: \(ugtTask.objectId)")
            }
            self.taskUserGroupTasks = userGroupTasks
            self.refreshControl.endRefreshing()
            self.updateTaskData()
        }
    }
    
    func getTaskLog(){
        let task = self.task
        let shouldLoadOldLogs = self.oldestLoadedLog != nil && self.loadingMoreLogs
        let userGroupTaskQuery = DesiUserGroupTask.query()
        userGroupTaskQuery?.whereKey("task", equalTo: task)
        
        let logQuery = DesiUserGroupTaskLog.query()
        logQuery?.includeKey("userGroupTask")
        logQuery?.includeKey("userGroupTask.userGroup")
        logQuery?.includeKey("userGroupTask.task")
        logQuery?.includeKey("userGroupTask.userGroup.user")
        logQuery?.whereKey("userGroupTask", matchesQuery: userGroupTaskQuery!)
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
            
            guard let logEntries = objects as? [DesiUserGroupTaskLog] else {
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
    
    func saveTaskState(){
        print("saving Task state")
        let block = ({
            (success: Bool, error: NSError?) -> Void in
            if success {
                print("updated")
            }
            else {
                print("new UserGroupsTask error")
            }
        })
        let ugtTasks : [PFObject] = self.taskUserGroupTasks
        let newLogs: [PFObject] = self.newLogEntries
        let taskState: [PFObject] = ugtTasks + newLogs
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
    }


}
