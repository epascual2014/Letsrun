//
//  PostsTableViewController.swift
//  Letsrun
//
//  Created by Edrick Pascual on 8/9/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class PostsTableViewController: UITableViewController {
    
    // Post array
    var posts = [Post]()
    
    // Currentuser names
    var loginName = ""
    
    //    static var imageCache: NSCache = NSCache()
    
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var captionTextfield: UITextField!
    
    @IBAction func postImageTapped(sender: AnyObject) {
        let postCaption = captionTextfield.text
        
        if postCaption != "" {
            let newPost: [String:AnyObject] = ["postCaption": postCaption!,
                                               "likes": 0,
                                               "loginName": loginName]
            DataSource.dataSource.createNewPost(newPost)
        }
    }
    
    var thisUser = Users?()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
    }
    
    
    //MARK: Fetchuser
    func fetchUser() {
        DataSource.dataSource.REF_USER_CURRENT.observeEventType(.Value, withBlock: { (snapshot) in
            let currentUser = snapshot.value?.objectForKey("loginName") as! String
            
            print("ED: \(currentUser)")
            self.loginName = currentUser
            }, withCancelBlock: { (error) in
                print(error.description)
        })
    }
    
    
    //        let userRef = ref.child("users")
    //        userRef.observeSingleEventOfType(.Value) { (userSnapshot: FIRDataSnapshot) in
    //            print(userSnapshot)
    //
    //            // Use self since its inside the function and intialized
    //            self.thisUser = Users(userSnapshot: userSnapshot)
    //        }
    
    func fetchPosts(){
        DataSource.dataSource.REF_POSTS.observeEventType(.Value, withBlock: { (snapshot) in
            print("ED: \(snapshot.value)")
            self.posts = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let postDictionary = snap.value as? [String:AnyObject] {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDictionary)
                        
                        self.posts.insert(post, atIndex: 0)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier") as? PostsTableViewCell {
            cell.configureCell(post)
        
            return cell
            
        } else {
            return PostsTableViewCell()
        }
    }
}

