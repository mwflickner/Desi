//
//  TaskActionTableViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 3/15/16.
//  Copyright © 2016 Desi. All rights reserved.
//

import UIKit

class TaskActionTableViewController: UITableViewController, UITextViewDelegate {
    
    var myUgtTask = DesiUserGroupTask()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userPointsLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskPointsLabel: UILabel!
    @IBOutlet weak var messageField: UITextView!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var optOutSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageField.delegate = self
        print(self.myUgtTask.userGroup.user.firstName)
        self.nameLabel.text = self.myUgtTask.userGroup.user.firstName
        self.userPointsLabel.text = "\(self.myUgtTask.userGroup.points) points"
        self.taskNameLabel.text = self.myUgtTask.task.taskName
        self.taskPointsLabel.text = "\(self.myUgtTask.task.pointValue) points"
        self.messageField.text = ""
        self.completeButton.enabled = false
        
        if (self.myUgtTask.isDesi){
            self.completeButton.setTitle("Complete", forState: .Normal)
        }
        else {
            self.completeButton.setTitle("Volunteer", forState: .Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func optOutAllowed() -> Bool {
        let ugPoints = self.myUgtTask.userGroup.points
        let optOutCost = self.myUgtTask.task.optOutCost
        let isDesi = self.myUgtTask.isDesi
        return ((ugPoints >= optOutCost) && isDesi)
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
            self.completeButton.enabled = true
        }
        else {
            self.completeButton.enabled = false
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            if optOutAllowed() {
                return 2
            }
            return 1
        }
        return 1
    }

    // MARK: - Text view delegate
    func textViewDidChange(textView: UITextView) {
        guard textView.text != "" else {
            self.completeButton.enabled = false
            return
        }
        self.completeButton.enabled = true
    }
    
    
    @IBAction func completeTapped(sender: UIBarButtonItem){
        sender.enabled = false
        //performSegueWithIdentifier("completeTaskSeuge", sender: self)
    }
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "completeTaskSegue" {
            let taskView = segue.destinationViewController as! TaskViewController
            if !self.myUgtTask.isDesi {
                taskView.volunteerCompleteTask(self.messageField.text)
            }
            else if optOutSwitch.on {
                taskView.optOutOfTask(self.messageField.text)
            }
            else {
                taskView.completeTask(self.messageField.text)
            }
            taskView.tableView.reloadData()
        }
    }

    
    

}
