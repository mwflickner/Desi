//
//  GroupSettingsMembersTableViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 4/13/16.
//  Copyright © 2016 Desi. All rights reserved.
//

import UIKit

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
    
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
//            if cell.accessoryType == .Checkmark {
//                if self.outputUserGroups.count > 1 {
//                    cell.accessoryType = .None
//                    self.outputUserGroups.removeAtIndex(indexPath.row)
//                    self.isMember[indexPath.row] = false
//                }
//            }
//            else {
//                cell.accessoryType = .Checkmark
//                self.outputUserGroups.insert(self.userGroups[indexPath.row], atIndex: indexPath.row)
//            }
//        }
//    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Members:"
        }
        return nil
    }
    
    func alertAdminActions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let makeAdminHander = { (action:UIAlertAction!) -> Void in
            print("swag")
        }
        
        let makeAdminAction = UIAlertAction(title: "Make Admin", style: .Default, handler: makeAdminHander)
        alertController.addAction(makeAdminAction)
        
        let removeUserHandler = { (action:UIAlertAction!) -> Void in
            print("hello")
        }
        let removeUserAction = UIAlertAction(title: "Remove From Group", style: .Destructive, handler: removeUserHandler)
        alertController.addAction(removeUserAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.myUserGroup.isGroupAdmin {
            alertAdminActions()
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! DesiTableViewCell
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
            let groupSettingsView = segue.destinationViewController as! GroupSettingsTableViewController
            groupSettingsView.userGroups = self.userGroups
            groupSettingsView.myUserGroup = self.myUserGroup
            groupSettingsView.tableView.reloadData()
        }
    }

}
