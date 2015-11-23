//
//  ProfileViewController.swift
//  Chipmunk
//
//  Created by Daniel Mathews on 2015-09-27.
//  Copyright © 2015 Daniel Mathews. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    var user:PFUser!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak internal var userNameLabel: UILabel!
    @IBOutlet weak internal var avatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        userNameLabel.text = user.username
        let avatarImage = user?.objectForKey("avatarImage") as? PFFile
        avatarImage?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.avatarImageView?.image = UIImage(data: data!)
            })
        })
        
        if user != PFUser.currentUser() {
            followButton.hidden = false
        }
        
    }

    @IBAction func followButtonPressed(sender: UIButton) {
        
        let data = [
            "alert" : "You have just followed \(user.username!)",
            "badge" : "Increment",
            "p" : "\(user.objectId!)"
        ]
        
        let push = PFPush()
        push.setChannel(PFUser.currentUser()!.objectId)
        push.setData(data)
        push.sendPushInBackground()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
