//
//  ViewController.swift
//  Chipmunk
//
//  Created by Daniel Mathews on 2015-09-26.
//  Copyright © 2015 Daniel Mathews. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    var imageFile:PFFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedProfileImageView(sender: UITapGestureRecognizer) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == passwordTextField {
            let user = PFUser()
            user.username = usernameTextField.text
            user.password = passwordTextField.text
            user.setObject(imageFile, forKey: "avatarImage")
            user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                if success {
                    print("\(user) signupe successfully")
                }
            })
        }
        
        return textField.resignFirstResponder()
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.contentMode = .ScaleAspectFill
            profileImageView.image = pickedImage
            
            if let data = UIImageJPEGRepresentation(pickedImage, 0.5){
                imageFile = PFFile(data: data)
                imageFile.saveInBackground()
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }


}

