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
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var message: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.hidden = true
        //DesiUser.logOut()
    }

    override func viewDidAppear(animated: Bool) {
        self.view.hidden = true
        if DesiUser.currentUser() != nil {
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
        else {
            self.view.hidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToLoginViewController(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func loginPressed(sender: UIButton) {
        self.loginButton.enabled = false
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        login()
    }
    
    func login(){
        var username = self.usernameTextField.text!
        username = username.lowercaseString
        let userPassword = self.passwordTextField.text
        
        PFUser.logInWithUsernameInBackground(username, password:userPassword!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                }
            } else {
                self.activityIndicator.stopAnimating()
                if let message1: AnyObject = error!.userInfo["error"] {
                    self.message = "\(message1)"
                    self.loginButton.enabled = true
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
            let homeView = nav.topViewController as! DesiHomeViewController
            homeView.getUserGroups()
        }
    }


}
