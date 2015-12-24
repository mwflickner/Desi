//
//  GroupMembersToAddTableViewCell.swift
//  Desi
//
//  Created by Matthew Flickner on 7/30/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit

class GroupMembersToAddTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var usersToAdd = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func removeUserFromList(sender: AnyObject){
        usersToAdd.removeAtIndex(sender.tag)
        self.tableView.reloadData()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersToAdd.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserToAddCell", forIndexPath: indexPath) as! DesiFriendTableViewCell
        cell.addButton.tag = indexPath.row
        cell.usernameLabel.text = usersToAdd[indexPath.row]
        return cell
        
    }


}
