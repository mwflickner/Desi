//
//  NewDesiGroupTableViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 5/31/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse

class NewDesiGroupTableViewController: UITableViewController {
    /*
    var homeButton : UIBarButtonItem = UIBarButtonItem(title: "LeftButtonTitle", style: UIBarButtonItemStyle.Plain, target: self, action: "")
    
    var logButton : UIBarButtonItem = UIBarButtonItem(title: "RigthButtonTitle", style: UIBarButtonItemStyle.Plain, target: self, action: "")
    
    self.navigationItem.leftBarButtonItem = homeButton
    */

    
    //@IBOutlet weak var newGroupNameTextField: UITextField!
    //@IBOutlet weak var userToAdd: UITextField!
    
    var newGroup: DesiGroup = DesiGroup()
    var myNewUserGroup: DesiUserGroup = DesiUserGroup()
    var userGroups: [DesiUserGroup]!
    var usersToAdd = [String]()
    
    //var newGroupUsernames: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem!.enabled = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //newGroupUsernames = [String]()
        self.myNewUserGroup.group = self.newGroup
        self.myNewUserGroup.user = DesiUser.currentUser()!

        self.myNewUserGroup.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                println("usergroup saved")
            } else {
                // There was a problem, check error.description
                println("UserGroup Error: \(error)")
            }
        })
        
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    /*
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            newGroupNameTextField.becomeFirstResponder()
        }
    }
    */
    

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
            return 2
        }
        else {
            return self.usersToAdd.count
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("newGroupNameCell", forIndexPath: indexPath) as! TextFieldTableViewCell
                cell.label.text = "Group Name:"
                cell.textField.addTarget(self, action: "checkNewGroupName:", forControlEvents: UIControlEvents.EditingChanged)
                tableView.rowHeight = 44
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier("searchForUserCell", forIndexPath: indexPath) as! TextFieldTableViewCell
                tableView.rowHeight = 100
                cell.textField.addTarget(self, action: "enableAdd:", forControlEvents: UIControlEvents.EditingChanged)
                cell.button.enabled = false
                cell.button.addTarget(self, action: "addUserToGroup:", forControlEvents: UIControlEvents.TouchUpInside)
                return cell
            }
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("UserToAddCell", forIndexPath: indexPath) as! DesiFriendTableViewCell
        cell.addButton.tag = indexPath.row
        cell.usernameLabel.text = usersToAdd[indexPath.row]
        cell.addButton.addTarget(self, action: "removeUserFromGroup:", forControlEvents: UIControlEvents.TouchUpInside)
        tableView.rowHeight = 44
        return cell
    }
    
    func isValidUsername(testStr: String) -> Bool {
        let usernameRegEx = "^[a-z0-9_-]{4,16}$"
        let usernameTest = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        return usernameTest.evaluateWithObject(testStr)
    }
    
    @IBAction func enableAdd(sender: UITextField) {
        let indexPath = NSIndexPath(forRow:1, inSection:0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! TextFieldTableViewCell
        if isValidUsername(sender.text){
            cell.button.enabled = true
        }
        else {
            cell.button.enabled = false
        }
    }
    
    @IBAction func addUserToGroup(sender: UIButton){
        println("add pressed")
        let indexPath = NSIndexPath(forRow:1, inSection:0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! TextFieldTableViewCell
        if cell.textField.text != "" {
            self.usersToAdd.append(cell.textField.text)
            cell.textField.text = ""
            //limit group size to 10
            if self.usersToAdd.count > 9 {
                sender.enabled = false
            }
            self.tableView.reloadData()
        }
        
        
    }
    
    @IBAction func removeUserFromGroup(sender: UIButton){
        self.usersToAdd.removeAtIndex(sender.tag)
        self.tableView.reloadData()
    }
    
    @IBAction func checkNewGroupName(sender: UITextField){
        let indexPath = NSIndexPath(forRow:0, inSection:0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! TextFieldTableViewCell
        if cell.textField.text == "" {
            self.navigationItem.rightBarButtonItem!.enabled = false
        }
        else {
            self.navigationItem.rightBarButtonItem!.enabled = true
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
        if segue.identifier == "createGroup" {
            
            self.myNewUserGroup.username = DesiUser.currentUser()!.username
            self.myNewUserGroup.isDesi = true
            self.myNewUserGroup.isGroupAdmin = true
            self.myNewUserGroup.groupPoints = 0
            
            
            let indexPath = NSIndexPath(forRow:0, inSection:0)
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! TextFieldTableViewCell
            self.newGroup.groupName = cell.textField.text
            
            self.newGroup.groupMembers = self.usersToAdd
            self.newGroup.groupMembers.insert(self.myNewUserGroup.username, atIndex: 0)
            self.newGroup.numberOfUsers = self.newGroup.groupMembers.count
        
            self.newGroup.theDesi = self.myNewUserGroup
            self.newGroup.setDesiIndex()
            
            
            //add the user group to the user's list of groups
            DesiUser.currentUser()!.userGroups.append(myNewUserGroup.objectId!)
        
            //store local first then update via network
            self.myNewUserGroup.pinInBackgroundWithName("MyUserGroups")
            self.myNewUserGroup.saveInBackgroundWithBlock({
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    println("usergroup saved")
                } else {
                    // There was a problem, check error.description
                    println("UserGroup Error: \(error)")
                    if error!.code == PFErrorCode.ErrorConnectionFailed.rawValue {
                        self.myNewUserGroup.saveEventually()
                    }
                }
            })
            
            for username in self.usersToAdd {
                var newUG = DesiUserGroup()
                newUG.username = username
                newUG.isDesi = false
                newUG.isGroupAdmin = false
                newUG.groupPoints = 0
                newUG.group = self.newGroup
                newUG.saveInBackgroundWithBlock({
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                        println("guest usergroup saved")
                    } else {
                        // There was a problem, check error.description
                        println("UserGroup Error: \(error)")
                        if error!.code == PFErrorCode.ErrorConnectionFailed.rawValue {
                            newUG.saveEventually()
                        }
                    }
                })
            }
            

        }
        else {
            self.myNewUserGroup.deleteEventually()
            self.newGroup.deleteEventually()
        }
    }


}
