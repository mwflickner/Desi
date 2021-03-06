//
//  CreateTaskTableViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 2/16/16.
//  Copyright © 2016 Desi. All rights reserved.
//

import UIKit
import Parse

class CreateTaskTableViewController: UITableViewController {
    
    var userGroups = [DesiUserGroup]()
    var outputUserGroups = [DesiUserGroup]()
    var newTask = DesiTask()
    var newUserGroupTasks = [DesiUserGroupTask]()
    
    let defaultTaskName = "Untitled Task"
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var pointValueSlider: UISlider!
    @IBOutlet weak var repeatsSwitch: UISwitch!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.outputUserGroups = self.userGroups
        self.membersLabel.text = ""
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        updateMembersLabel()
        let numberOfDesis = 1
        let pointValue = Int(self.pointValueSlider.value)
        self.newTask = createNewTask(defaultTaskName, numberOfDesis: numberOfDesis, pointValue: pointValue)
        self.pointsLabel.text = String(pointValue)
        self.newTask.repeats = self.repeatsSwitch.on
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
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
        for userGroup in self.outputUserGroups {
            self.membersLabel.text = self.membersLabel.text! + userGroup.user.firstName + " " + userGroup.user.lastName + ", "
        }
        self.tableView.reloadData()
    }

    @IBAction func sliderValueChanged(sender: UISlider) {
        let currentValue = Int(sender.value)
        self.newTask.pointValue = currentValue
        self.pointsLabel.text = "\(currentValue)"
    }
    
    @IBAction func taskNameValueChanged(sender: UITextField){
        let name = sender.text
        if let taskName = name {
            self.newTask.taskName = taskName
        }
        else {
            self.newTask.taskName = defaultTaskName
        }
        print(self.newTask.taskName)
    }
    
    @IBAction func taskRepeatingToggled(sender: UISwitch){
        self.newTask.repeats = sender.on
        print(sender.on)
    }
    
    @IBAction func backToCreateTaskView(segue:UIStoryboardSegue){
        
    }
    
    func createNewTask(taskName: String, numberOfDesis: Int, pointValue: Int) -> DesiTask {
        let newTask = DesiTask()
        newTask.taskName = taskName
        newTask.numberOfDesis = numberOfDesis
        newTask.pointValue = pointValue
        print(pointValue)
        newTask.optOutCost = 5*pointValue
        print(newTask.optOutCost)
        return newTask
    }
    
    func createNewUserGroupTask(userGroup: DesiUserGroup, queueSpot: Int, task: DesiTask) -> DesiUserGroupTask {
        let newUserGroupTask = DesiUserGroupTask()
        newUserGroupTask.userGroup = userGroup
        newUserGroupTask.task = task
        newUserGroupTask.queueSpot = queueSpot
        newUserGroupTask.isDesi = queueSpot < task.numberOfDesis
        return newUserGroupTask
    }
    
    func buildUserGroupTasks(userGroups: NSSet, task: DesiTask) -> [DesiUserGroupTask] {
        var newUserGroupTasks = [DesiUserGroupTask]()
        print(self.userGroups.count)
        for (index,userGroup) in userGroups.enumerate() {
            let newUgt = createNewUserGroupTask(userGroup as! DesiUserGroup, queueSpot: index, task: task)
            newUserGroupTasks.append(newUgt)
        }
        return newUserGroupTasks
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "createTaskSegue" {
            let groupView = segue.destinationViewController as! GroupTableViewController
            groupView.refreshControl.beginRefreshing()
            self.newUserGroupTasks = buildUserGroupTasks(Set(self.outputUserGroups), task: newTask)
            let block = {
                (success: Bool, error: NSError?) -> Void in
                guard success else {
                    print("new UserGroupsTask error")
                    groupView.refreshControl.endRefreshing()
                    return
                }
                print("new UserGroupsTask saved")
                groupView.userGroupTasks = groupView.userGroupTasks + self.newUserGroupTasks
                print("about to filter")
                groupView.filterUserGroupTasks()
                groupView.filterUserGroupTasksByTask()
                groupView.refreshControl.endRefreshing()
                groupView.tableView.reloadData()
            }
            PFObject.saveAllInBackground(self.newUserGroupTasks, block: block)
        }
        
        if segue.identifier == "manageTaskMembers" {
            let nav = segue.destinationViewController as! UINavigationController
            let manageMembers = nav.topViewController as! TaskMembersTableViewController
            manageMembers.userGroups = self.userGroups
            manageMembers.outputUserGroups = self.outputUserGroups
        }
    }


}
