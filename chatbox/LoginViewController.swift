//
//  LoginViewController.swift
//  chatbox
//
//  Created by DeVaris Brown on 5/20/15.
//  Copyright (c) 2015 Furious One. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpButtonTapped(sender: AnyObject) {
        var user = PFUser()
        let username = emailTextField.text
        let password = passwordTextField.text
        
        user.username = username
        user.password = password
        
        user.signUpInBackgroundWithBlock {
            (succeeded, error) -> Void in
            if error == nil {
                self.performSegueWithIdentifier("authSegue", sender: self)
            } else {
                let errorString = error!.userInfo!["error"] as! NSString
                println("Error: \(errorString)")
            }
        }
    }

    @IBAction func signInButtonTapped(sender: AnyObject) {
        let username = emailTextField.text
        let password = passwordTextField.text
        
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user, error) -> Void in
            if user != nil {
                self.performSegueWithIdentifier("authSegue", sender: self)
            } else {
                var alert = UIAlertController(title: "Invalid Auth Credentials", message: "You Entered a Bad Email/Password", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                println("Error: \(error)")
            }
        }
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
