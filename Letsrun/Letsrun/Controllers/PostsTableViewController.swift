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
    
    // Store posts in an array
    var posts = [Post]()
    
    // Store currentuser name
    var currentUsername = ""
    
    // Call Phototakinghelper class
    var photoTakingHelper: PhotoTakingHelper?
    
    @IBOutlet weak var cameraImageView: CircleView!
    @IBOutlet weak var commentTextfield: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        fetchPosts()
    }
    
    
    // MARK: Fetchuser
    func fetchUser() {
        guard let userID = FIRAuth.auth()?.currentUser?.uid else {
            return }
        DataSource.dataSource.REF_USERS.child(userID).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            print("ED: Snapshot ---> \(snapshot)")
            let username = snapshot.value!["loginName"] as! String
            self.currentUsername = username
        })
    }

    // MARK: Fetchposts
    func fetchPosts(){
        DataSource.dataSource.REF_POSTS.observeEventType(.Value, withBlock: { (snapshot) in
            print("ED: \(snapshot.value)")
            self.posts = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let postDictionary = snap.value as? [String:AnyObject] {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDictionary)
                        self.posts.append(post)
                        //self.posts.insert(post, atIndex: 0)
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

