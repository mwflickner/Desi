//
//  GroupSettingsMembersTableViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 4/13/16.
//  Copyright © 2016 Desi. All rights reserved.
//

import UIKit
import Parse

class GroupMembersTableViewController: UITableViewController {

    var userGroups = [DesiUserGroup]()
    var myUserGroup = DesiUserGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.userGroups.count
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Members:"
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectable: Bool = (indexPath.section == 1 &&
                                self.myUserGroup.isGroupAdmin &&
                                self.myUserGroup.user.objectId != self.userGroups[indexPath.row].user.objectId)
        if selectable {
            alertAdminActions(indexPath)
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! DesiTableViewCell
            cell.button.addTarget(self, action: #selector(addUserToGroup), forControlEvents: .TouchUpInside)
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("memberCell", forIndexPath: indexPath) as! DesiTableViewCell
        let firstName = self.userGroups[indexPath.row].user.firstName
        let lastName = self.userGroups[indexPath.row].user.lastName
        cell.label1.text = "\(firstName) \(lastName)"
        if self.userGroups[indexPath.row].isGroupAdmin{
            cell.accessoryType = .Checkmark
        }
        else {
            cell.accessoryType = .None
        }
        return cell
    }
    
    @IBAction func addUserToGroup(sender: UIButton){
        sender.enabled = false
        let path = NSIndexPath(forRow: 0, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(path) as! DesiTableViewCell
        let usernameToAdd = cell.textField.text!
        print(usernameToAdd)
        let block = {
            (objects: [PFObject]?, error: NSError?) -> Void in
            guard error == nil else {
                print("Error: \(error!) \(error!.userInfo)")
                sender.enabled = true
                return
            }
            // The find succeeded.
            print("Successfully retrieved \(objects!.count) users. Swag.")
            // Do something with the found objects
            guard let users = objects as? [DesiUser] where users.count == 1 else {
                setErrorColor(cell.textField)
                sender.enabled = true
                return
            }
            let newUser: DesiUser = users[0]
            let newUserGroup = createUserGroup(newUser, isAdmin: false, group: self.myUserGroup.group)
            newUserGroup.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if success {
                    print("new usergroup saved")
                }
                else {
                    print("new UserGroup error error")
                }
            }
            self.userGroups.append(newUserGroup)
            self.tableView.reloadData()
            sender.enabled = true
        }
        findUserByUsername(usernameToAdd, block: block)
        sender.enabled = true
    }
    
    func alertAdminActions(indexPath: NSIndexPath) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let makeAdminHander = { (action:UIAlertAction!) -> Void in
            self.userGroups[indexPath.row].isGroupAdmin = !self.userGroups[indexPath.row].isGroupAdmin
            self.tableView.reloadData()
        }
        
        let adminTitle : String = self.userGroups[indexPath.row].isGroupAdmin ? "Remove as Admin" : "Make Admin"
        
        let makeAdminAction = UIAlertAction(title: adminTitle, style: .Default, handler: makeAdminHander)
        alertController.addAction(makeAdminAction)
        
        let removeUserHandler = { (action:UIAlertAction!) -> Void in
            let ugToDelete = self.userGroups[indexPath.row]
            leaveGroup(ugToDelete)
            self.userGroups.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
        }
        
        let removeUserAction = UIAlertAction(title: "Remove From Group", style: .Destructive, handler: removeUserHandler)
        alertController.addAction(removeUserAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }

    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
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
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "backToGroupSettings" {
            print("swaggg")
            let groupSettingsView = segue.destinationViewController as! GroupSettingsTableViewController
            print(self.userGroups.count)
            print(groupSettingsView.userGroups.count)
            groupSettingsView.userGroups = self.userGroups
            groupSettingsView.myUserGroup = self.myUserGroup
            print(self.userGroups.count)
            print(groupSettingsView.userGroups.count)
            groupSettingsView.updateMembersLabel()
        }
    }

}
