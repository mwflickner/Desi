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
    
    var hasViewedLog: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var completeButton: UIBarButtonItem!
    @IBOutlet weak var optOutButton: UIBarButtonItem!
    @IBOutlet weak var segControl : UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
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
        if indexPath.section == 1 {
            return 80
        }
        else {
            return 60
        }
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
        
        logCell.label1.text = "\(firstName) \(lastName) \(verb) at \(logEntry.timeCompleted)"
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
                if ugTask.isDesi {
                    self.completeButton.title = "Complete"
                }
                else {
                    self.completeButton.title = "Volunteer"
                }
            }
        }
        self.updateActionButtons()
    }
    
    func shouldEnableActionButtons() -> Bool {
        return true
//        if self.myUgTask != nil {
//            let lastUpdated = self.myUgTask!.updatedAt
//            let created = self.myUgTask!.createdAt
//            if (lastUpdated!.compare(created!) == .OrderedSame) {
//                return true
//            }
//            let currentDate = NSDate()
//            let secondsInterval = Int(currentDate.timeIntervalSinceDate(lastUpdated!))
//            print(secondsInterval)
//            let minutesInterval = secondsInterval/60
//            print("mintues = \(minutesInterval)")
//            if minutesInterval >= 5 {
//                return true
//            }
//        }
//        return false
    }
    
    func updateActionButtons(){
        if shouldEnableActionButtons() {
            if let myUgTask = self.myUgTask {
                if optOutAllowed(myUgTask){
                    self.optOutButton.enabled = true
                }
                else {
                    self.optOutButton.enabled = false
                }
            }
            self.completeButton.enabled = true
        }
        else {
            self.completeButton.enabled = false
            self.optOutButton.enabled = false
        }
    }
    
    func optOutAllowed(ugTask: DesiUserGroupTask) -> Bool {
        if ugTask.isDesi {
            if ugTask.userGroup.points < 5 * ugTask.task.pointValue {
                return false
            }
            return true
        }
        return false
    }
    
    func completeTask(){
        let oldDesiUGTasks = self.desiUgTasks
        self.newLogEntries = []
        for oldDesi in oldDesiUGTasks {
            let taskPoints = self.task.pointValue
            oldDesi.userGroup.points += taskPoints
            let logEntry = DesiUserGroupTaskLog()
            logEntry.userGroupTask = oldDesi
            logEntry.actionMessage = "Task done"
            logEntry.actionType = "completion"
            logEntry.timeCompleted = NSDate()
            self.taskLog.append(logEntry)
            self.newLogEntries.append(logEntry)
            //oldDesi.userGroup.user.desiScore += taskPoints
        }
        self.desiUgTasks = []
        let range = Range<Int>(start: 0,end: self.task.numberOfDesis)
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
        self.completeButton.title = "Volunteer"
        self.saveTaskState()
        self.updateActionButtons()
    }
    
    func volunteerCompleteTask(){
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
        logEntry.actionMessage = "Volunteer done"
        logEntry.actionType = "volunteer"
        logEntry.timeCompleted = NSDate()
        self.taskLog.append(logEntry)
        self.newLogEntries.append(logEntry)
        self.saveTaskState()
        self.updateActionButtons()
    }
    
    func optOutOfTask(){
        self.desiUgTasks = []
        if let myUgTask = self.myUgTask {
            myUgTask.isDesi = false
            myUgTask.userGroup.points -= 5*self.task.pointValue
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
            logEntry.actionMessage = "Opting out"
            logEntry.actionType = "opt-out"
            logEntry.timeCompleted = NSDate()
            self.taskLog.append(logEntry)
            self.newLogEntries.append(logEntry)
            self.saveTaskState()
            self.updateActionButtons()
        }
        else {
            // exception
        }
    }
    
    func getUserGroupTasksForTask(task: DesiTask){
        let query = DesiUserGroupTask.query()
        query?.includeKey("task")
        query?.includeKey("userGroup")
        query?.includeKey("userGroup.user")
        query?.includeKey("userGroup.group")
        query?.whereKey("task", equalTo: task)
        query?.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject]{
                    if let userGroupTasks = objects as? [DesiUserGroupTask]{
                        for ugtTask in userGroupTasks {
                            print("Task ID: \(ugtTask.task.objectId)")
                            print("UGT TaskID: \(ugtTask.objectId)")
                        }
                        self.taskUserGroupTasks = userGroupTasks
                        self.updateTaskData()
                    }
                }
            }
        }
    }
    
    func getTaskLog(task: DesiTask){
        let userGroupTaskQuery = DesiUserGroupTask.query()
        userGroupTaskQuery?.whereKey("task", equalTo: task)
        
        let logQuery = DesiUserGroupTaskLog.query()
        logQuery?.includeKey("userGroupTask")
        logQuery?.includeKey("userGroupTask.userGroup")
        logQuery?.includeKey("userGroupTask.task")
        logQuery?.includeKey("userGroupTask.userGroup.user")
        logQuery?.whereKey("userGroupTask", matchesQuery: userGroupTaskQuery!)
        logQuery?.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject]{
                    if let logEntries = objects as? [DesiUserGroupTaskLog]{
                        self.taskLog = logEntries
                        if self.segControl.selectedSegmentIndex == 1 {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
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
        let ugtTasks : [AnyObject] = self.taskUserGroupTasks
        let newLogs: [AnyObject] = self.newLogEntries
        let taskState: [AnyObject] = ugtTasks + newLogs
        PFObject.saveAllInBackground(taskState, block: block)
        
    }

    @IBAction func completeTapped(sender: UIBarButtonItem){
        sender.enabled = false
        print("meooow")
        let isVolunteerCompletion = (sender.title == "Volunteer")
        if !isVolunteerCompletion {
            completeTask()
        }
        else {
            volunteerCompleteTask()
        }
        
        self.tableView.reloadData()
        sender.enabled = true
    }
    
    @IBAction func optOutTapped(sender: UIBarButtonItem){
        sender.enabled = false
        print("optout")
        optOutOfTask()
        self.tableView.reloadData()
        sender.enabled = true
    }
    
    @IBAction func segControlChanged(sender: UISegmentedControl){
        sender.enabled = false
        if sender.selectedSegmentIndex == 1{
            if !hasViewedLog {
                self.getTaskLog((self.myUgTask?.task)!)
                self.hasViewedLog = true
            }
            self.tableView.reloadData()
            sender.enabled = true
        }
        else {
            self.getUserGroupTasksForTask(self.task)
            sender.enabled = true
            self.tableView.reloadData()
        }
       
    }
    
    
    @IBAction func updateDesiGroupSettings(segue:UIStoryboardSegue) {
        
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        /*
        
        */
    }


}
