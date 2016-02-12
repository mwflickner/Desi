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
    var taskUserGroupTasks = [Int: DesiUserGroupTask]()
    
    var myUgTask: DesiUserGroupTask!
    var desiUgTask: DesiUserGroupTask!
    
    var task: DesiTask!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.navigationItem.title = task.taskName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 80
        }
        else {
            return 60
        }
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("Path is \(indexPath.row)")
        if indexPath.section == 0 {
            let desiCell = tableView.dequeueReusableCellWithIdentifier("TheDesiCell", forIndexPath: indexPath) as! DesiTableViewCell
            desiCell.label1.text = self.taskUserGroupTasks[indexPath.row]!.userGroup.user.username
            return desiCell
        }
        if indexPath.section == 1 {
            let onDeckCell = tableView.dequeueReusableCellWithIdentifier("OnDeckCell", forIndexPath: indexPath) as! DesiTableViewCell
            onDeckCell.label1.text = self.taskUserGroupTasks[((indexPath.row + self.task.numberOfDesis) % self.taskUserGroupTasks.count)]!.userGroup.user.username
            return onDeckCell
        }
        let restCell = tableView.dequeueReusableCellWithIdentifier("RestOfGroupCell", forIndexPath: indexPath) as! DesiTableViewCell
        
        restCell.label1.text = self.taskUserGroupTasks[((indexPath.row + 2*self.task.numberOfDesis) % self.taskUserGroupTasks.count)]!.userGroup.user.username
        return restCell
    }

    /*
    @IBAction func wentOutTapped(sender: UIButton) {
        sender.enabled = false
        
        for ugt in self.ugTasks {
            if ugt.isDesi{
                ugt.isDesi = false
                ugt.saveInBackgroundWithBlock({
                    (success: Bool, error: NSError?) -> Void in
                    if success {
                        print("oldDesi updated")
                    }
                    else {
                        print("oldDesi error")
                    }
                })
            }
        }
        
        for var i = 0; i < self.ugTasks.count; ++i {
            if self.theTask.members[(self.theTask.desiIndex + 1)%theTask.members.count] == ugTasks[i].userGroup.username {
                ugTasks[i].isDesi = true
                self.theTask.theDesi = self.ugTasks[i].userGroup.username
                self.theTask.desiIndex = (theTask.desiIndex + 1)%(theTask.members.count)
                ugTasks[i].saveInBackgroundWithBlock({
                    (success: Bool, error: NSError?) -> Void in
                    if success {
                        print("newDesi updated")
                        sender.enabled = true
                        self.tableView.reloadData()
                    }
                    else {
                        print("newDesi error")
                    }
                })
                break
            }
        }
        
    }
    
    @IBAction func volunteerTapped(sender: UIButton) {
        print("volunteer tapped")
        sender.enabled = false
        for var i = 0; i < self.ugTasks.count; ++i {
            print("ugt \(self.ugTasks[i].objectId)")
        }
        
        for ugt in self.ugTasks {
            print("for loop?")
            if ugt.isDesi{
                print("if?")
                ugt.isDesi = false
                ugt.saveInBackgroundWithBlock({
                    (success: Bool, error: NSError?) -> Void in
                    if success {
                        print("oldDesi updated")
                    }
                    else {
                        print("oldDesi error")
                    }
                })
            }
        }
        self.theTask.theDesi = DesiUser.currentUser()!.username!
        self.theTask.setDesiIndex()
        
        print("hello?")
        for var i = 0; i < self.ugTasks.count; ++i {
            if self.ugTasks[i].userGroup.username == self.theTask.theDesi {
                self.ugTasks[i].isDesi = true
                //self.theTask.userSwap(self.theTask.desiIndex, index2: i)
                print("users swapped")
                self.ugTasks[i].saveInBackgroundWithBlock({
                    (success: Bool, error: NSError?) -> Void in
                    if success {
                        print("newDesi updated")
                        sender.enabled = true
                        self.tableView.reloadData()
                    }
                    else {
                        print("newDesi error")
                    }
                })
                
            }
        }
    
    }
    */
    
    
    
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
