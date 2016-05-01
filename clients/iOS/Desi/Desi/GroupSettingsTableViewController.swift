//
//  GroupSettingsTableViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 7/6/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse

class GroupSettingsTableViewController: UITableViewController {
    
    var tasks: [DesiTask]!
    var userGroups = [DesiUserGroup]()
    var myUserGroup: DesiUserGroup!
    var isAdmin = false
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var updateNameButton: UIButton!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var leaveGroupButton: UIButton!
    @IBOutlet weak var deleteGroupButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("groupName is \(self.myUserGroup.group.groupName)")
        print("\(DesiUser.currentUser()?.username)")
        self.isAdmin = self.myUserGroup.isGroupAdmin
        self.navigationItem.title = "Group Settings"
        self.nameTextField.text = self.myUserGroup.group.groupName
        if !isAdmin {
            self.nameTextField.enabled = false
            self.updateNameButton.enabled = false
        }
        updateMembersLabel()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return 1
        }
        if section == 2 {
//            if isAdmin {
//                return 2
//            }
            return 1
        }
        return 0
    }
    
    func updateMembersLabel(){
        self.membersLabel.text = ""
        print(self.userGroups.count)
        for userGroup in self.userGroups {
            self.membersLabel.text = self.membersLabel.text! + userGroup.user.firstName + " " + userGroup.user.lastName + ", "
        }
        self.tableView.reloadData()
    }
    
    func updateGroupName(){
        let newName = self.nameTextField.text
        self.myUserGroup.group.groupName = newName!
        
        let block = ({
            (success: Bool, error: NSError?) -> Void in
            guard success else {
                print("new groupName error")
                return
            }
            print("new GroupNameSaved")
        })
        
        self.myUserGroup.saveInBackgroundWithBlock(block)
    }
    
    @IBAction func updateNamePressed(sender: UIButton){
        sender.enabled = false
        updateGroupName()
        sender.enabled = true
    }
    
    @IBAction func leaveGroupPressed(sender: UIButton){
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to leave the group?", preferredStyle: .ActionSheet)
        
        let cancelHandler = { (action:UIAlertAction!) -> Void in
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelHandler)
        alertController.addAction(cancelAction)
        
        let leaveHandler = { (action:UIAlertAction!) -> Void in
            if self.userGroups.count == 1 {
                self.performSegueWithIdentifier("deleteGroupSegue", sender: self)
            }
            else {
                self.assignNewAdminIfNeeded()
                self.performSegueWithIdentifier("leaveGroupSegue", sender: self)
            }
        }
        let leaveAction = UIAlertAction(title: "Leave", style: .Destructive, handler: leaveHandler)
        alertController.addAction(leaveAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteGroupPressed(sender:UIButton){
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete the group?", preferredStyle: .ActionSheet)
        
        let cancelHandler = { (action:UIAlertAction!) -> Void in
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelHandler)
        alertController.addAction(cancelAction)
        
        let deleteHandler = { (action:UIAlertAction!) -> Void in
            self.performSegueWithIdentifier("deleteGroupSegue", sender: self)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: deleteHandler)
        alertController.addAction(deleteAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func backToGroupSettings(sender: UIStoryboardSegue){
        
    }
    
    func assignNewAdminIfNeeded(){
        let admins: [DesiUserGroup] = self.userGroups.filter({$0.isGroupAdmin})
        if self.myUserGroup.isGroupAdmin && admins.count == 1 {
            var swag: [DesiUserGroup] = self.userGroups.filter({$0.objectId != myUserGroup.objectId})
            swag[0].isGroupAdmin = true
            let block = ({
                (success: Bool, error: NSError?) -> Void in
                if success {
                    print("admins updated")
                }
                else {
                    print("new UserGroups error")
                }
            })
            PFObject.saveAllInBackground(swag, block: block)
        }
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
        
        if segue.identifier == "backToGroup" {
            let group = segue.destinationViewController as! GroupTableViewController
            print("okay then")
            let block = {
                (objects: [PFObject]?, error: NSError?) -> Void in
                guard error == nil else {
                    return
                }
                guard let userGroups = objects as? [DesiUserGroup] else {
                    return
                }
                for userGroup in userGroups {
                    group.userGroups[userGroup.objectId!] = userGroup
                }
                group.refreshControl.endRefreshing()
            }
            getUserGroupsForGroup(self.myUserGroup.group, block: block)
        }
        
        if segue.identifier == "showMembers" {
            let nav = segue.destinationViewController as! DesiNaviagtionController
            let membersView = nav.topViewController as! GroupMembersTableViewController
            membersView.userGroups = self.userGroups
            membersView.myUserGroup = self.myUserGroup
        }
        
        if segue.identifier == "deleteGroupSegue" {
            print("deleting group")
            let home = segue.destinationViewController as! DesiHomeViewController
            home.refreshControl.beginRefreshing()
            let block = {
                (deleteSuccessful: Bool, error: NSError?) -> Void in
                guard error == nil else {
                    print(error)
                    home.refreshControl.endRefreshing()
                    return
                }
                
                guard deleteSuccessful else {
                    print("delete failed")
                    home.refreshControl.endRefreshing()
                    return
                }
                
                print("succesfully deleted group")
                home.myUserGroups = home.myUserGroups.filter({$0.objectId != self.myUserGroup.objectId})
                home.refreshControl.endRefreshing()
                home.tableView.reloadData()

            }
            self.myUserGroup.group.deleteInBackgroundWithBlock(block)
                    }
        
        if segue.identifier == "leaveGroupSegue" {
            print("leaving group")
            let home = segue.destinationViewController as! DesiHomeViewController
            home.refreshControl.beginRefreshing()
            let block = {
                (deleteSuccessful: Bool, error: NSError?) -> Void in
                guard error == nil else {
                    print(error)
                    home.refreshControl.endRefreshing()
                    return
                }
                
                guard deleteSuccessful else {
                    print("delete failed")
                    home.refreshControl.endRefreshing()
                    return
                }
                
                print("succesfully left group")
                home.myUserGroups = home.myUserGroups.filter({$0.objectId != self.myUserGroup.objectId})
                home.refreshControl.endRefreshing()
                home.tableView.reloadData()
            }
            self.myUserGroup.deleteInBackgroundWithBlock(block)
        }
    }


}
