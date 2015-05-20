//
//  ChatViewController.swift
//  chatbox
//
//  Created by DeVaris Brown on 5/20/15.
//  Copyright (c) 2015 Furious One. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var messages: [String] = []

    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chatTable.dataSource = self
        self.chatTable.delegate = self
        self.retrieveMessages()
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "retrieveMessages", userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendTapped(sender: AnyObject) {
        var message = PFObject(className: "Message")
        message["text"] = messageTextField.text
        message["user"] = PFUser.currentUser()
        messageTextField.text = nil
        message.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                println("\(PFUser.currentUser()?.username) your message has been saved")
                self.retrieveMessages()
            } else {
                println("error")
            }
        }

    }
    
    func retrieveMessages() {
        var query:PFQuery = PFQuery(className: "Message")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error:NSError?) -> Void in
            
            self.messages = [String]()
            
            if let objs = objects {
                for messageObject in objs {
                    let messageText:String? = (messageObject as! PFObject)["text"] as? String
                    if messageText != nil {
                        self.messages.append(messageText!)
                    }
                    
                }
            }
            self.chatTable.reloadData()
        } 
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = chatTable.dequeueReusableCellWithIdentifier("ChatCell") as! ChatCell
        cell.messageLabel.text = messages[indexPath.row]
        
        return cell
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
