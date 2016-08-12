//
//  ActiveTweetsTableViewController.swift
//  Letsrun
//
//  Created by Edrick Pascual on 7/21/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ActiveTweetsTableViewController: UITableViewController {
    
    var databaseReferance: FIRDatabaseReference!
    
    var tweetsArray = [Tweets]()

    override func viewDidLoad() {
        super.viewDidLoad()
        databaseReferance =  FIRDatabase.database().reference().child("tweet-items")
        startObservingDatabase()
           }

    
    func startObservingDatabase() {
        databaseReferance.observeEventType(.Value, withBlock: { (snapshot:FIRDataSnapshot) in
        
            var newTweetsArray = [Tweets]()
            
            // for loop to get objects in array in Firebase snapshot database
            for tweets in snapshot.children {
                
                // Cast to object
                let tweetObject = Tweets(snapshot: tweets as! FIRDataSnapshot)
                newTweetsArray.append(tweetObject)
            }
            
            self.tweetsArray = newTweetsArray
            self.tableView.reloadData()
            
        }) { (error:NSError) in
            print(error.description)
        }
    }
    
    @IBAction func addTweetTapped(sender: UIBarButtonItem) {
        
        let tweetAlert = UIAlertController(title: "New Tweet", message: "Enter your message", preferredStyle: .Alert)
        tweetAlert.addTextFieldWithConfigurationHandler { (textField:UITextField) in
            textField.placeholder = "Your Tweet"
        }
        tweetAlert.addAction(UIAlertAction(title: "Send", style: .Default, handler: { (action:UIAlertAction) in
            if let tweetContent = tweetAlert.textFields?.first?.text {
                
                // Tweet object and pass to firebase
                let userTweet = Tweets(content: tweetContent, addedByUser: "" )
                
                // Create a tweet reference to firebase and add the child.
                let tweetReference = self.databaseReferance.child(tweetContent.lowercaseString)
                
                //
                tweetReference.setValue(userTweet.toAnyObject())
                
            }
        }))
        
        self.presentViewController(tweetAlert, animated: true, completion: nil)
    }
   

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetsArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCellWithIdentifier("displayTweets", forIndexPath: indexPath) as! ActiveTweetsTableViewCell
        
        let tweet = tweetsArray[indexPath.row]
        cell.currentTweetLabel?.text = tweet.content
        cell.userLabel.text = tweet.addedByUser

        return cell
    }
    
    // User can delete tweets
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let userTweets = tweetsArray[indexPath.row]
        
        userTweets.itemRef?.removeValue()
    }
    
    
   }
