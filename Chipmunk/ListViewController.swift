//
//  ListViewController.swift
//  Chipmunk
//
//  Created by Daniel Mathews on 2015-09-27.
//  Copyright © 2015 Daniel Mathews. All rights reserved.
//

import UIKit
import Parse

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var users:[PFUser]?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()
        query?.findObjectsInBackgroundWithBlock({ (users, error) -> Void in
            
            print("in query with counts of users = \(users?.count)")
            
            if let myUsers = users as? [PFUser] {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.users = myUsers
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toProfileView" {
            
            let indexPath = tableView.indexPathForCell(sender as! ListTableViewCell)
            let user = users?[indexPath!.row]
            let profileView = segue.destinationViewController as! ProfileViewController
            profileView.user = user
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listCell", forIndexPath: indexPath) as! ListTableViewCell
        let user = users?[indexPath.row]
        cell.userNameLabel?.text = user?.username
        let avatarImage = user?.objectForKey("avatarImage") as? PFFile
        avatarImage?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                cell.avatarImageView?.image = UIImage(data: data!)
            })
        })
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

}