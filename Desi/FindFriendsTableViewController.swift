//
//  FindFriendsTableViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 7/28/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse

class FindFriendsTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var myFriends: [DesiFriendship]!
    var searchOn = false
    var results: [DesiUser]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Search Bar functions
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchOn = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchOn = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchOn = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchOn = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText: searchText)
    }
    
    
    func search(searchText: String? = nil){
        let query = DesiUser.query()
        query!.whereKey("username", containsString: searchText)
        query!.includeKey("friendList")
        if (searchText != "") {
            query!.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        // The find succeeded.
                        println("Successfully retrieved \(objects!.count) scores.")
                        // Do something with the found objects
                        if let objects = objects as? [PFObject] {
                            let users = objects as! [DesiUser]
                            self.results = users
                            self.tableView.reloadData()
                        }
                    }
                }
                else {
                    // Log details of the failure
                    println("Error: \(error!) \(error!.userInfo!)")
                }
            }

        }
        
    }
    
    func userAtIndexPath(indexPath: NSIndexPath) -> DesiUser {
        return results[indexPath.row]
    }
    
    func userAtRow(row: Int) -> DesiUser {
        return results[row]
    }
    
    @IBAction func addFriend(sender: AnyObject){
        let path = self.tableView.indexPathForSelectedRow()!
        var newFriendship = DesiFriendship()
        if self.myFriends == nil {
            self.myFriends = [DesiFriendship]()
        }
        println("about to save")
        newFriendship.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                println("we back nigga")
                // The object has been saved.
                newFriendship.user1 = DesiUser.currentUser()!
                newFriendship.username1 = DesiUser.currentUser()!.username!
                println("step1")
                //let path = self.tableView.indexPathForSelectedRow()!
                var newFriend = self.userAtIndexPath(path)
                println("\(newFriend.username)")
                
                newFriendship.user2 = newFriend
                newFriendship.username2 = newFriend.username!
                println("step 3")
                
                newFriendship.friendshipAccepted = false
                
                DesiUser.currentUser()!.friendList.friendships.append(newFriendship)
                DesiUser.currentUser()!.friendList.friendshipsIds.append(newFriendship.objectId!)
                ++DesiUser.currentUser()!.friendList.numberOfFriends
                println("step 4")
                
                newFriend.friendList.friendships.append(newFriendship)
                 println("step 5")
                
                newFriend.friendList.friendshipsIds.append(newFriendship.objectId!)
                ++newFriendship.user2.friendList.numberOfFriends
                
               println("step6")
                
                //save the new friendship to network and local
                newFriendship.pinInBackgroundWithName("MyFriends")
                newFriendship.saveInBackgroundWithBlock({
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        println("friendship updated")
                    }
                    else {
                        println("friendship couldn't be updated")
                    }
                })
                
                self.myFriends.insert(newFriendship, atIndex: 0)
                println("friendship saved")
                
                
                //send a push notification to other user here
                
                //reload the table
                self.tableView.reloadData()
                
                
                
            }
            else {
                // There was a problem, check error.description
                println("friendship Error: \(error)")
                if error!.code == PFErrorCode.ErrorConnectionFailed.rawValue {
                    println("network error")
                }
            }
        })

        //will allow for quick navigation back to friends list
        //self.myFriends.insert(newFriendship, atIndex: 0)
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if (self.results != nil){
            return self.results.count
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath) as! DesiFriendTableViewCell
        cell.nameLabel.text = results[indexPath.row].firstName + " " + results[indexPath.row].lastName
        cell.usernameLabel.text = results[indexPath.row].username
        cell.desiPointsLabel.text = "Desi Points: " + String(results[indexPath.row].desiPoints)
        if myFriends != nil {
            for friendship in myFriends {
                if ((results[indexPath.row].objectId == friendship.user1.objectId) || (results[indexPath.row].objectId == friendship.user2.objectId)){
                    let image = UIImage(named: "glyphicons-194-circle-ok") as UIImage?
                    cell.addButton.setImage(image, forState: .Normal)
                    cell.addButton.tag = indexPath.row
                    cell.addButton.enabled = false
                }
            }
        }
        

        return cell
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
        if (segue.identifier == "BackToFriendListSegue") {
            
        }
    }


}
