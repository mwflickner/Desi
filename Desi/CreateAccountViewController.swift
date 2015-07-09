//
//  CreateAccountViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 7/7/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit

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
    
    func nameCheck(nameField: UITextField) {
        if nameField.text == "" {
            setErrorColor(nameField)
            //return false
        }
        else {
            setSuccessColor(nameField)
            //return true
        }
    }
    
    func isValidUsername(testStr: String) -> Bool {
        let usernameRegEx = "^[a-z0-9_-]{3,16}$"
        let usernameTest = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        return usernameTest.evaluateWithObject(testStr)
    }
    
    func usernameCheck(usernameField: UITextField){
        usernameField.text = usernameField.text.lowercaseString
        if isValidUsername(usernameField.text) {
            setSuccessColor(usernameField)
        }
        else {
            setErrorColor(usernameField)
        }
        //still need to check database for other usernames
    }
    
    func isValidPassword(testStr: String) -> Bool {
        let passwordRegEx = "^[a-z0-9_-]{6,256}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluateWithObject(testStr)
    }
    
    func passwordCheck(passwordField: UITextField){
        if isValidPassword(passwordField.text){
            setSuccessColor(passwordField)
        }
        else {
            setErrorColor(passwordField)
        }
    }
    
    func passwordsMatch(){
        println("passwords check")
        if password1.text == password2.text {
            setSuccessColor(password1)
            setSuccessColor(password2)
        }
        else {
            setErrorColor(password1)
            setErrorColor(password2)
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        println("email valid ran")
        return emailTest.evaluateWithObject(testStr)
    }
    
    func emailCheck(email: UITextField){
        if isValidEmail(email.text){
            println("email good")
            setSuccessColor(email)
        }
        else {
            setErrorColor(email)
            println("email bad")
        }
    }
    
    func emailsMatch(){
        if email1.text == email2.text {
            setSuccessColor(email1)
            setSuccessColor(email2)
            println("emails match")
            //return true
        }
        else {
            setErrorColor(email1)
            setErrorColor(email2)
            println("emails match")
            //return false
        }
    }
    
    @IBAction func firstNameDone(sender: AnyObject) {
        nameCheck(firstName)
    }
    
    @IBAction func lastNameDone(sender: AnyObject) {
        nameCheck(lastName)
    }
    
    @IBAction func usernameDone(sender : AnyObject) {
        usernameCheck(username)
    }
    
    @IBAction func password1Done(sender: AnyObject) {
        passwordCheck(password1)
        if(password2.text != ""){
            passwordsMatch()
        }
        
    }
    
    @IBAction func password2Done(sender: AnyObject) {
        passwordCheck(password2)
        if(password1.text != ""){
            passwordsMatch()
        }
    }
    
    @IBAction func email1Done(sender: AnyObject) {
        println("email1 done")
        emailCheck(email1)
        if(email2.text != ""){
            emailsMatch()
        }
        
    }
    
    @IBAction func email2Done(sender: AnyObject) {
        println("email2 done")
        emailCheck(email2)
        if(email1.text != ""){
            emailsMatch()
        }
    }
    
    
    func enableButton(){
        createButton.enabled = true
    }
    
    func createAccount(){
        
    }
    
    @IBAction func createTapped(sender : AnyObject) {
        println("created tapped")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
