//
//  LoginViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 7/7/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var message: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        DesiUser.logOut()
        var isThereUser = DesiUser.currentUser()?.username
        if isThereUser != nil {
            println("\(DesiUser.currentUser()!.username)")
        }
        else {
            println("we good its nil")
            
        }
        
        self.activityIndicator.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToLoginViewController(segue:UIStoryboardSegue) {
        
    }
    
    func verifyUsername(name: String){
        
    }
    
    
    @IBAction func signIn(sender: UIButton) {
        sender.enabled = false
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
            
        var username1 = self.username.text
        username1 = username1.lowercaseString
            
        var userPassword = self.password.text
            
        PFUser.logInWithUsernameInBackground(username1, password:userPassword) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                }
            } else {
                self.activityIndicator.stopAnimating()
                    
                if let message1: AnyObject = error!.userInfo!["error"] {
                    self.message = "\(message1)"
                    sender.enabled = true
                }
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "loginSegue"){
            let nav = segue.destinationViewController as! UINavigationController
            var homeView = nav.topViewController as! DesiHomeViewController
            
            let query = DesiUserGroup.query()
            query!.whereKey("username", equalTo: DesiUser.currentUser()!.username!)
            query!.includeKey("group.theDesi")
            query!.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in

                if error == nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        // The find succeeded.
                        println("Successfully retrieved \(objects!.count) scores.")
                        // Do something with the found objects
                        if let objects = objects as? [PFObject] {
                            let userGroups = objects as? [DesiUserGroup]
                            homeView.myUserGroups = userGroups
                            
                            //store found userGroups in Localstore
                            DesiUserGroup.pinAllInBackground(homeView.myUserGroups, withName:"MyUserGroups")
                            
                            homeView.tableView.reloadData()
                            
                        }
                    }
                    
                } else {
                    // Log details of the failure
                    println("Error: \(error!) \(error!.userInfo!)")
                }
            }

        }
        
    }


}
