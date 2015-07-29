//
//  DesiFriendListViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 7/28/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse

class DesiFriendListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var myFriends: [DesiFriendship]!
    var filteredFriends: [DesiFriendship] = []
    var searchOn: Bool = false
    
    var data = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    var filtered:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        /*
        self.myFriends = [DesiFriendship]()
        var testFriend = DesiUser()
        testFriend.firstName = "Test"
        testFriend.lastName = "Friend"
        testFriend.username = "testfriend1"
        testFriend.desiPoints = 0
        
        var friendship = DesiFriendship()
        friendship.user1 = DesiUser.currentUser()!
        friendship.user2 = testFriend
        friendship.friendshipAccepted = true
        myFriends.append(friendship)
        
        var testFriend2 = DesiUser()
        testFriend2.firstName = "John"
        testFriend2.lastName = "Smith"
        testFriend2.username = "jsmith1"
        testFriend2.desiPoints = 0
        
        var friendship2 = DesiFriendship()
        friendship2.user1 = DesiUser.currentUser()!
        friendship2.user2 = testFriend2
        friendship2.friendshipAccepted = true
        myFriends.append(friendship2)
        */
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchOn = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchOn = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchOn = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchOn = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredFriends = self.myFriends.filter({ (friendship: DesiFriendship) -> Bool in
            if friendship.user1.objectId == DesiUser.currentUser()!.objectId {
                let name : NSString = friendship.user2.firstName + " " + friendship.user2.lastName
                let stringMatch = name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return stringMatch.location != NSNotFound
            }
            else {
                let name: NSString = friendship.user1.firstName + " " + friendship.user1.lastName
                let stringMatch = name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return stringMatch.location != NSNotFound
            }
        })
        if (self.filteredFriends.count == 0){
            self.searchOn = false;
        }
        else {
            searchOn = true;
        }
        self.tableView.reloadData()

    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchOn {
            return filteredFriends.count
        }
        else {
            if myFriends == nil {
                return 0
            }
            return myFriends.count
        }
        
    }

    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let friendCell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) as! DesiFriendTableViewCell
        if searchOn {
            if self.filteredFriends[indexPath.row].user1.objectId == DesiUser.currentUser()!.objectId {
                friendCell.desiPointsLabel.text = "Desi Points: " + String(self.filteredFriends[indexPath.row].user2.desiPoints)
                friendCell.nameLabel.text = self.filteredFriends[indexPath.row].user2.firstName + " " + self.filteredFriends[indexPath.row].user2.lastName
                friendCell.usernameLabel.text = self.filteredFriends[indexPath.row].user2.username
                return friendCell
            }
            
            friendCell.desiPointsLabel.text = "Desi Points: " + String(self.filteredFriends[indexPath.row].user1.desiPoints)
            friendCell.nameLabel.text = self.filteredFriends[indexPath.row].user1.firstName + " " + self.filteredFriends[indexPath.row].user1.lastName
            friendCell.usernameLabel.text = self.filteredFriends[indexPath.row].user1.username
            return friendCell
        }
        else {
            if self.myFriends[indexPath.row].user1.objectId == DesiUser.currentUser()!.objectId {
                friendCell.desiPointsLabel.text = "Desi Points: " + String(self.myFriends[indexPath.row].user2.desiPoints)
                friendCell.nameLabel.text = self.myFriends[indexPath.row].user2.firstName + " " + self.myFriends[indexPath.row].user2.lastName
                friendCell.usernameLabel.text = self.myFriends[indexPath.row].user2.username
                return friendCell
            }
            
            friendCell.desiPointsLabel.text = "Desi Points: " + String(self.myFriends[indexPath.row].user1.desiPoints)
            friendCell.nameLabel.text = self.myFriends[indexPath.row].user1.firstName + " " + self.myFriends[indexPath.row].user1.lastName
            friendCell.usernameLabel.text = self.myFriends[indexPath.row].user1.username
            return friendCell
        }
        
    }

    @IBAction func backToDesiFriendListViewController(segue:UIStoryboardSegue) {
        if let addFriendVC = segue.sourceViewController as? FindFriendsTableViewController {
            self.myFriends = addFriendVC.myFriends
            self.tableView.reloadData()
            //let indexPath = NSIndexPath(forRow: myUserGroups.count, inSection: 0)
            //tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "GoToFriendAddSegue"){
            let nav = segue.destinationViewController as! UINavigationController
            var findFriends = nav.topViewController as! FindFriendsTableViewController
            findFriends.myFriends = self.myFriends
        }
    }


}
