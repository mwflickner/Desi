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

    
    @IBOutlet weak var newGroupNameTextField: UITextField!
    
    var newGroup: DesiGroup = DesiGroup()
    
    var newUserGroup: DesiUserGroup = DesiUserGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.newUserGroup.group = self.newGroup
        self.newUserGroup.user = DesiUser.currentUser()!

        self.newUserGroup.saveInBackgroundWithBlock({
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            newGroupNameTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func logout(){
        DesiUserGroup.unpinAllObjectsInBackgroundWithName("MyUserGroups")
        self.newUserGroup.deleteEventually()
        self.newGroup.deleteEventually()
        DesiUser.logOut()
        var currentUser = DesiUser.currentUser() // this will now be nil
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    


    // MARK: - Table view data source
    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }
    */
    

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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
            
            self.newUserGroup.username = DesiUser.currentUser()!.username
            self.newUserGroup.isDesi = true
            self.newUserGroup.isGroupAdmin = true
            self.newUserGroup.groupPoints = 0
            
            
            //DesiUser.currentUser()!.userGroups.append(newUserGroup)
            
            self.newGroup.groupName = self.newGroupNameTextField.text
            
            //new array for members and then assign the new UserGroup
            
            self.newGroup.groupMembers = [String]()
            self.newGroup.groupMembers.append(self.newUserGroup.username)
            self.newGroup.numberOfUsers = self.newGroup.groupMembers.count
            
            self.newGroup.theDesi = self.newUserGroup
            
            //add the user group to the user's list of groups
            DesiUser.currentUser()!.userGroups.append(newUserGroup.objectId!)
        
            //store local first then update via network
            self.newUserGroup.pinInBackgroundWithName("MyUserGroups")
            self.newUserGroup.saveInBackgroundWithBlock({
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    println("usergroup saved")
                } else {
                    // There was a problem, check error.description
                    println("UserGroup Error: \(error)")
                    if error!.code == PFErrorCode.ErrorConnectionFailed.rawValue {
                        self.newUserGroup.saveEventually()
                    }
                }
            })
            

        }
        else {
            self.newUserGroup.deleteEventually()
            self.newGroup.deleteEventually()
        }
    }


}
