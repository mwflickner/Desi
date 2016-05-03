//
//  LoginViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 7/7/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginFeedbackLabel: UILabel!
    
    @IBOutlet weak var fbLoginButton: UIButton!
    
    var message: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.hidden = true
        self.activityIndicator.hidesWhenStopped = true
        self.loginFeedbackLabel.hidden = true
        if FBSDKAccessToken.currentAccessToken() != nil {
            if DesiUser.currentUser() == nil {
                FBSDKAccessToken.setCurrentAccessToken(nil)
                FBSDKProfile.setCurrentProfile(nil)
            }
        }

    }

    override func viewDidAppear(animated: Bool) {
        self.view.hidden = true
        if DesiUser.currentUser() == nil {
            if FBSDKAccessToken.currentAccessToken() != nil {
                getFacebookUserDetails()
            }
            else {
                self.view.hidden = false
            }
        }
        else {
            guard FBSDKAccessToken.currentAccessToken() != nil else {
                DesiUser.logOut()
                return
            }
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
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
    
    @IBAction func loginFacebookPressed(sender: UIButton){
        loginWithFacebook()
    }
    
    
    func login(){
        var username = self.usernameTextField.text!
        username = username.lowercaseString
        let userPassword = self.passwordTextField.text
        DesiUser.logInWithUsernameInBackground(username, password:userPassword!) {
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
    
    func loginWithFacebook() {
        let permissions = ["public_profile", "email", "user_friends"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: {
            (user: PFUser?, error: NSError?) -> Void in
            guard user != nil else {
                print("no user")
                return
            }
            print(user)
            self.getFacebookUserDetails()
        })
        
    }
    
    func getFacebookUserDetails() {
        let parameters = ["fields": "id, email, first_name, last_name"]
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: parameters)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            guard error == nil else {
                print(error)
                DesiUser.logOut()
                return
            }
            print("fetched user: \(result)")
            let userId: String = result.valueForKey("id") as! String
            let firstName: String = result.valueForKey("first_name") as! String
            let lastName: String = result.valueForKey("last_name") as! String
            let email : String = result.valueForKey("email") as! String
            print(userId)
            print(firstName)
            print(lastName)
            print(email)
            print("meow")
            let user = DesiUser.currentUser()!
            user.firstName = firstName
            user.lastName = lastName
            user.email = email
            user.username = email
            user.saveInBackgroundWithBlock({
                (success: Bool, error: NSError?) -> Void in
                guard success else {
                    print("user save error")
                    DesiUser.logOut()
                    return
                }
                print("user saved")
                //self.performSegueWithIdentifier("loginSegue", sender: self)
            })
        })
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
