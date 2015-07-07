//
//  TheGroupTableViewController.swift
//  Desi
//
//  Created by Matthew Flickner on 6/18/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit

class TheGroupTableViewController: UITableViewController {
    
    var theGroup: DesiGroup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("groupName is \(self.theGroup.groupName)")
        self.navigationItem.title = self.theGroup.groupName
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

         //Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         //self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return theGroup.numberOfUsers
    }
    
    /*
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == 1 {
            return 80
        }
        else {
            return 44
        }
    }
    */

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("Path is \(indexPath.row)")
        if (indexPath.row == 0){
            var desiCell = tableView.dequeueReusableCellWithIdentifier("TheDesiCell", forIndexPath: indexPath) as! TheDesiTableViewCell
            desiCell.theDesiNameLabel.text = theGroup.theDesi.userName
            desiCell.theDesiImg.image = theGroup.theDesi.userImage(theGroup.theDesi.userImg)
            println("returning DesiCell")
            return desiCell
        }
        if (indexPath.row == 1){
            var onDeckCell = tableView.dequeueReusableCellWithIdentifier("OnDeckCell", forIndexPath: indexPath) as! OnDeckTableViewCell
            var nextDesi: DesiUser = theGroup.getUserFromDesi(1)
            onDeckCell.onDeckLabel.text = nextDesi.userName
            onDeckCell.onDeckImg.image = nextDesi.userImage(nextDesi.userImg)
            println("returning onDeckCell")
            return onDeckCell
        }
        else {
            var restCell = tableView.dequeueReusableCellWithIdentifier("RestOfGroup", forIndexPath: indexPath) as! RestOfGroupTableViewCell
            var user: DesiUser = theGroup.getUserFromDesi(indexPath.row)
            restCell.restOfGroupLabel.text = user.userName
            restCell.restOfGroupImg.image = user.userImage(user.userImg)
            println("returning other cell")
            return restCell
        }

        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
