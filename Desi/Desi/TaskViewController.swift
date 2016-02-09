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
    
    var myUgTask: DesiUserGroupTask!
    var desiUgTask: DesiUserGroupTask!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        //self.taskUserGroupTasks
        self.navigationItem.title = self.taskUserGroupTasks[0].task.taskName
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setMyUgTask(){
        for ugTask in self.taskUserGroupTasks {
            if ugTask.userGroup.user == DesiUser.currentUser() {
                self.myUgTask = ugTask
                return
            }
        }
        // should not get here
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if section == 0 {
        //    if self.theTask.theDesi == DesiUser.currentUser()?.username{
        //        return self.theTask.members.count + 1
        //    }
        //    return self.theTask.members.count
        //}
        return 1
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 80
        }
        else {
            return 44
        }
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("Path is \(indexPath.row)")
        let desiCell = tableView.dequeueReusableCellWithIdentifier("TheDesiCell", forIndexPath: indexPath) as! TheDesiTableViewCell
        return desiCell
        /*
        if indexPath.section == 0 {
            if (indexPath.row == 0){
                let desiCell = tableView.dequeueReusableCellWithIdentifier("TheDesiCell", forIndexPath: indexPath) as! TheDesiTableViewCell
                if (DesiUser.currentUser()!.username == self.theTask.theDesi) {
                    print("swag")
                    desiCell.theDesiNameLabel.text = "YOU are the Desi"
                    desiCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                }
                else {
                    desiCell.theDesiNameLabel.text = self.theTask.theDesi
                }
                //desiCell.theDesiImg.image = theGroup.theDesi.userImg
                print("returning DesiCell")
                return desiCell
            }
            if (indexPath.row == 1){
                if self.theTask.members.count > 1 {
                    let onDeckCell = tableView.dequeueReusableCellWithIdentifier("OnDeckCell", forIndexPath: indexPath) as! OnDeckTableViewCell
                    let nextDesi: String = self.theTask.getUserFromDesi(1)
                    onDeckCell.onDeckLabel.text = nextDesi
                    //onDeckCell.onDeckImg.image = nextDesi.userImage(nextDesi.userImg)
                    print("returning onDeckCell")
                    return onDeckCell
                }
            }
            if (indexPath.row >= self.theTask.members.count && DesiUser.currentUser()?.username == self.theTask.theDesi){
                
                let groupActionCell = tableView.dequeueReusableCellWithIdentifier("GroupActionsCell", forIndexPath: indexPath) as! GroupActionsTableViewCell
                groupActionCell.actionButton.setTitle("Task Completed", forState: UIControlState.Normal)
                groupActionCell.actionButton.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
                groupActionCell.actionButton.addTarget(self, action: "wentOutTapped:", forControlEvents: UIControlEvents.TouchUpInside)
                print("returning button cell")
                return groupActionCell
               
                
            }
            
            let restCell = tableView.dequeueReusableCellWithIdentifier("RestOfGroupCell", forIndexPath: indexPath) as! RestOfGroupTableViewCell
            let userGroup: String = self.theTask.getUserFromDesi(indexPath.row)
            restCell.restOfGroupLabel.text = userGroup
            //restCell.restOfGroupImg.image = userGroup.user.userImg
            print("returning other cell")
            return restCell


        }
        let groupActionCell = tableView.dequeueReusableCellWithIdentifier("GroupActionsCell", forIndexPath: indexPath) as! GroupActionsTableViewCell
        groupActionCell.actionButton.setTitle("Volunteer", forState: UIControlState.Normal)
        groupActionCell.actionButton.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
        groupActionCell.actionButton.addTarget(self, action: "volunteerTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        print("returning button cell")
        return groupActionCell
        
       */
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
