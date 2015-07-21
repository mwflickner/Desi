//
//  CreateAccountViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 7/7/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var email1: UITextField!
    @IBOutlet weak var email2: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //createButton.enabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //user feedback on text fields
    func setErrorColor(textField: UITextField) {
        var errorColor : UIColor = UIColor.redColor()
        textField.layer.borderColor = errorColor.CGColor
        textField.layer.borderWidth = 1.5
    }
    
    func setSuccessColor(textField: UITextField) {
        var successColor : UIColor = UIColor( red: 0.3, green: 0.5, blue:0.3, alpha: 1.0 )
        textField.layer.borderColor = successColor.CGColor
        textField.layer.borderWidth = 1.5
    }
    
    //check the name fields
    func nameCheck(nameField: UITextField) -> Bool {
        if nameField.text != "" {
            return true
        }
        return false
    }
    
    @IBAction func firstNameDone(sender: AnyObject) {
        if nameCheck(self.firstName) {
            setSuccessColor(self.firstName)
            return
        }
        setErrorColor(self.firstName)
    }
    
    @IBAction func lastNameDone(sender: AnyObject) {
        if nameCheck(lastName){
            setSuccessColor(lastName)
            return
        }
        setErrorColor(lastName)
    }
    
    //check the usernames
    func isValidUsername(testStr: String) -> Bool {
        let usernameRegEx = "^[a-z0-9_-]{3,16}$"
        let usernameTest = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        return usernameTest.evaluateWithObject(testStr)
    }
    
    func usernameCheck(usernameField: UITextField) -> Bool{
        usernameField.text = usernameField.text.lowercaseString
        if isValidUsername(usernameField.text) {
            setSuccessColor(usernameField)
            return true
        }
        else {
            setErrorColor(usernameField)
            return false
        }
    }
    
    @IBAction func usernameDone(sender : AnyObject) {
        if (isValidUsername(self.username.text) && usernameCheck(self.username)){
            setSuccessColor(self.username)
            return
        }
        setErrorColor(username)
    }
    
    // password functions
    func isValidPassword(testStr: String) -> Bool {
        let passwordRegEx = "^[a-z0-9_-]{6,256}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluateWithObject(testStr)
    }
    
    
    func passwordsMatch() -> Bool{
        println("passwords check")
        if password1.text == password2.text {
            return true
        }
        return false
    }
    
    @IBAction func password1Done(sender: AnyObject) {
        if isValidPassword(password1.text) {
            if(password2.text != ""){
                if passwordsMatch(){
                    setSuccessColor(password2)
                }
                else {
                    setErrorColor(password2)
                    setErrorColor(password1)
                    return
                }
            }
            setSuccessColor(password1)
            return
        }
        setErrorColor(password1)
        
    }
    
    @IBAction func password2Done(sender: AnyObject) {
        if isValidPassword(password2.text) {
            if(password1.text != ""){
                if passwordsMatch(){
                    setSuccessColor(password1)
                }
                else {
                    setErrorColor(password2)
                    setErrorColor(password1)
                    return
                }
            }
            setSuccessColor(password2)
            return
        }
        setErrorColor(password2)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        println("email valid ran")
        return emailTest.evaluateWithObject(testStr)
    }
    
    func emailCheck(email: UITextField) -> Bool{
        if isValidEmail(email.text){
            println("email good")
            setSuccessColor(email)
            return true
        }
        setErrorColor(email)
        println("email bad")
        return false
        
    }
    
    func emailsMatch() -> Bool{
        if email1.text == email2.text {
            setSuccessColor(email1)
            setSuccessColor(email2)
            println("emails match")
            return true
        }
        setErrorColor(email1)
        setErrorColor(email2)
        println("emails match")
        return false
    }
    
    
    
    @IBAction func email1Done(sender: AnyObject) {
        println("email1 done")
        emailCheck(email1)
        if(email2.text != ""){
            emailsMatch()
        }
        //set the array in these functions
        
    }
    
    @IBAction func email2Done(sender: AnyObject) {
        println("email2 done")
        emailCheck(email2)
        if(email1.text != ""){
            emailsMatch()
        }
    }
    
    
    
    func createAccount(){
        let newUser = DesiUser()
        newUser.username = self.username.text
        newUser.password = self.password1.text
        newUser.email = self.email1.text
        newUser.firstName = self.firstName.text
        newUser.lastName = self.lastName.text
        newUser.userGroups = [DesiUserGroup]()
        newUser.desiPoints = 0
        newUser.signUpInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                println("success")
                self.performSegueWithIdentifier("createAccountSegue", sender: nil)
            }
            else {
                println("\(error)")
                // Show the errorString somewhere and let the user try again.
            }
        }
    }
    
    @IBAction func createTapped(sender : AnyObject) {
        println("created tapped")
        createAccount()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "createAccountSegue") {
            let nav = segue.destinationViewController as! UINavigationController
            var groupsView = nav.topViewController as! DesiGroupsTableViewController
            groupsView.myGroups = self.userGroups
        }

    }
    */


}
