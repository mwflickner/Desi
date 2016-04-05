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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if isAdmin {
            return 3
        }
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return 1
        }
        if section == 2 {
            if isAdmin {
                return 2
            }
            return 1
        }
        return 0
    }
    
    func updateMembersLabel(){
        self.membersLabel.text = ""
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
        sender.enabled = false
    }
    
    @IBAction func deleteGroupPressed(sender:UIButton){
        sender.enabled = false
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
        if segue.identifier == "leaveGroupFromSettingsSegue" {
            //print yo whats up
        }
    }


}
