//
//  LoginViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 7/7/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginFeedbackLabel: UILabel!
    
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    var message: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.hidden = true
        self.activityIndicator.hidesWhenStopped = true
        self.loginFeedbackLabel.hidden = true
        self.fbLoginButton.delegate = self
        
        // Support Coming Soon
        self.fbLoginButton.enabled = false
        self.fbLoginButton.hidden = true
        self.fbLoginButton.delegate = self
        //DesiUser.logOut()
    }

    override func viewDidAppear(animated: Bool) {
        self.view.hidden = true
//        if (FBSDKAccessToken.currentAccessToken() != nil)
//        {
//            self.performSegueWithIdentifier("loginSegue", sender: self)
//        }
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
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if error != nil {
            // Process error
        }
        
        if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            guard error != nil else {
                // Process error
                print("Error: \(error)")
                return
            }
            print("fetched user: \(result)")
            let userName : NSString = result.valueForKey("name") as! NSString
            print("User Name is: \(userName)")
            let userEmail : NSString = result.valueForKey("email") as! NSString
            print("User Email is: \(userEmail)")
        })
    }
    
    @IBAction func backToLoginViewController(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func loginPressed(sender: UIButton) {
        self.loginButton.enabled = false
        self.loginFeedbackLabel.hidden = true
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
                self.loginFeedbackLabel.hidden = false
                if let message1: AnyObject = error!.userInfo["error"] {
                    self.message = "\(message1)"
                }
                self.loginButton.enabled = true
            }
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "loginSegue"){
            let split = segue.destinationViewController as! UISplitViewController
            let nav = split.viewControllers.last as! DesiNaviagtionController
            let homeView = nav.topViewController as! DesiHomeViewController
            homeView.getUserGroups()
        }
    }


}
