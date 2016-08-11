//
//  UsersTableViewController.swift
//  Letsrun
//
//  Created by Edrick Pascual on 7/25/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import UIKit
import Firebase

class UsersTableViewController: UITableViewController {

    
    var ref: FIRDatabaseReference!
    
    // Array of users from model class
    var userArray = [Users]()
    
    // Array of invited friends
    var friendsList = [String:AnyObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        fetchUsers()
    }
    
    //MARK: Fetching users from Firebase database
    func fetchUsers() {
        let userRef = ref.child("users")
        userRef.observeEventType(.Value) { (userSnapshot: FIRDataSnapshot) in
            self.userArray.removeAll()
            for snap in userSnapshot.children {
                let user = Users(userSnapshot: (snap as! FIRDataSnapshot))
                
                // Adds value to the group
                if FIRAuth.auth()?.currentUser?.uid != user.uid {
                    self.userArray.append(user)
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("usersIdentifier", forIndexPath: indexPath) as! UsersTableViewCell
        
        cell.delegate = self
        
        let user = userArray[indexPath.row]
        cell.user = user
                
        return cell
    }
}  


extension UsersTableViewController: UsersTableViewCellDelegate {
    
    func cell(cell: UsersTableViewCell, didSelectFollowUser user: Users) {
        print(#function)
        
        // Once click, user adds to his list of friends
        ref.child("users").child(FIRAuth.auth()!.currentUser!.uid).child("friendsList").child(user.uid!).setValue(true)
        ref.child("users").child(user.uid!).child("friendsList").child(FIRAuth.auth()!.currentUser!.uid).setValue(true)

    }
    
    func cell(cell: UsersTableViewCell, didSelectUnfollowUser user: Users) {
        print(#function)
        
//         Once click, unfriend user remove from list of friends
        ref.child("users").child(FIRAuth.auth()!.currentUser!.uid).child("friendsList").child(user.uid!).removeValue()
        ref.child("users").child(user.uid!).child("friendsList").child(FIRAuth.auth()!.currentUser!.uid).removeValue()

    }

    
}





