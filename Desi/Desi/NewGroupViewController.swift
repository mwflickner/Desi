//
//  NewDesiGroupTableViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 5/31/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse

class NewGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var myNewUserGroup: DesiUserGroup = DesiUserGroup()
    var newUserGroups = [DesiUserGroup]()
    var newGroup = DesiGroup()
    
    var createButton: UIBarButtonItem!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupNameTextField : UITextField!
    @IBOutlet weak var memberToAddTextField: UITextField!
    @IBOutlet weak var addMemberButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        borderTableView(self.tableView)
        
        
        createButton = self.navigationItem.rightBarButtonItem!
        createButton.enabled = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        self.myNewUserGroup = createUserGroup(DesiUser.currentUser()!, isAdmin: true)
        self.newUserGroups.append(self.myNewUserGroup)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Group Members"
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newUserGroups.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserToAddCell", forIndexPath: indexPath) as! DesiTableViewCell
        cell.label1.text = self.newUserGroups[indexPath.row].user.username
        cell.label2.text = String(self.newUserGroups[indexPath.row].user.desiScore)
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        }
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            self.newUserGroups.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    
    func userInGroupAlready() -> Bool {
        for member in self.newUserGroups {
            if self.memberToAddTextField.text == member.user.username {
                setErrorColor(self.memberToAddTextField)
                self.memberToAddTextField.text = "Already in group"
                return true
            }
        }
        return false
    }
    
    @IBAction func enableAdd(sender: UITextField) {
        if isValidUsername(sender.text!) {
            self.addMemberButton.enabled = true
        }
        else {
            self.addMemberButton.enabled = false
        }
    }
    
    @IBAction func enableCreate(sender: UITextField) {
        if sender.text != "" {
            //self.newGroup.groupName = sender.text!
            self.createButton.enabled = true
            return
        }
        self.createButton.enabled = false
    }

    
    @IBAction func addUserToGroup(sender: UIButton){
        print("add pressed")
        sender.enabled = false
        if !userInGroupAlready(){
            let usernameToAdd = self.memberToAddTextField.text!
            let query = DesiUser.query()
            query!.whereKey("username", equalTo: usernameToAdd)
            query!.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) users. Swag.")
                    // Do something with the found objects
                    if let objects = objects as? [PFObject] {
                        let users = objects as? [DesiUser]
                        if users!.count == 1 {
                            let newUser: DesiUser = users![0]
                            self.newUserGroups.append(self.createUserGroup(newUser, isAdmin: false))
                            self.tableView.reloadData()
                        }
                        else {
                            setErrorColor(self.memberToAddTextField)
                        }
                        sender.enabled = true
                    }
                }
                else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                    sender.enabled = true
                }
            }
        }
        sender.enabled = true
    }
    
    func createUserGroup(user: DesiUser, isAdmin: Bool) -> DesiUserGroup {
        let newUserGroup: DesiUserGroup = DesiUserGroup()
        newUserGroup.group = self.newGroup
        newUserGroup.user = user
        newUserGroup.isGroupAdmin = isAdmin
        newUserGroup.points = 0
        return newUserGroup
    }
    
    
    func createGroup(){
        self.newGroup.groupName = self.groupNameTextField.text!
        let block = ({
            (success: Bool, error: NSError?) -> Void in
            if success {
                print("new UserGroups saved")
            }
            else {
                print("new UserGroups error")
            }
        })
        
        PFObject.saveAllInBackground(self.newUserGroups, block: block)
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "createNewGroup" {
            print("got here")
            createGroup()
        }

    }



}
