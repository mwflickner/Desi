//
//  TheGroupTableViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 6/18/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse

class TaskTableViewController: UITableViewController {
    var theTask: DesiTask!
    var ugTasks: [DesiUserGroupTask]!
    var myUgTask: DesiUserGroupTask!
    var desiUgTask: DesiUserGroupTask!
    var userGroup: DesiUserGroup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.theTask.taskName
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

         //Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         //self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if DesiUser.currentUser()!.username == self.theTask.theDesi{
            return 1
        }
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
            if self.theTask.theDesi == DesiUser.currentUser()?.username{
                return self.theTask.members.count + 1
            }
            return self.theTask.members.count
        }
        return 1
        
    }
    
    /*
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == 1 {
            return 80
        }
        else {
            return 44
        }
    }
    */

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("Path is \(indexPath.row)")
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
        
        
    }
    
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
    
    
    
    @IBAction func updateDesiGroupSettings(segue:UIStoryboardSegue) {
        
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        /*
        
        */
    }


}
