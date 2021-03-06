//
//  MasterViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 3/12/16.
//  Copyright © 2016 Desi. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var detailViewController: DesiHomeViewController?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers.last as? DesiHomeViewController
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView()
        headerView.backgroundColor = UIColor.lightGrayColor()
        return headerView
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView: UIView = UIView()
        headerView.backgroundColor = UIColor.lightGrayColor()
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
            case 0: return 15
            case 1: return 0
            case 2: return 0
            case 3: return 15
            case 4: return 15
            default: return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
            case 0: return 0
            case 1: return 0
            case 2: return 0
            case 3: return 0
            case 4: return 15
            default: return 0
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0: return 0
            case 1: return 0
            case 2: return 1
            case 3: return 1
            case 4: return 1
            default: return 0
        }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        func displayLogoutAlert(){
            let firstName = DesiUser.currentUser()!.firstName
            let lastName = DesiUser.currentUser()!.lastName
            let alertController = UIAlertController(title: nil, message: "Currently logged in as \(firstName) \(lastName)", preferredStyle: .ActionSheet)
            
            let cancelHander = { (action:UIAlertAction!) -> Void in
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelHander)
            alertController.addAction(cancelAction)
            
            let logoutHandler = { (action:UIAlertAction!) -> Void in
                self.logout()
            }
            let logoutAction = UIAlertAction(title: "Logout", style: .Destructive, handler: logoutHandler)
            alertController.addAction(logoutAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
        
        if indexPath.section == 4 {
            if indexPath.row == 0 {
                displayLogoutAlert()
            }
        }
    }
    
    
    func logout(){
        DesiUserGroup.unpinAllObjectsInBackground()
        DesiUser.logOut()
        _ = DesiUser.currentUser() // this will now be nil
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func backToMasterView(segue: UIStoryboardSegue) {
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToGroups" {
            let nav = segue.destinationViewController as! DesiNaviagtionController
            let groups = nav.topViewController as! DesiHomeViewController
            groups.getUserGroups()
        }
    }


}
