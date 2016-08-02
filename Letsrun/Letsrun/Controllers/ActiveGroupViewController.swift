//
//  ActiveGroupViewController.swift
//  Letsrun
//
//  Created by Edrick Pascual on 7/12/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import UIKit
import Firebase

class ActiveGroupViewController: UIViewController {
    
    var currentGroup: Group?
    
    var ref: FIRDatabaseReference!
    var groupsRef: FIRDatabaseReference!
    
    
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupDescription: UITextView!
    
    @IBOutlet weak var joinGroupButton: UIButton!
    @IBAction func joinGroupTapped(sender: AnyObject) {
//        if currentGroup?.groupMembers == true {
        if joinGroupButton.titleLabel?.text == "JOIN GROUP"{
            joinGroupButton.setTitle("LEAVE GROUP", forState: .Normal)
            //                joinGroup()
            print("JOIN")
            print(currentGroup)
        } else {
            //                unJoinGroup()
            joinGroupButton.setTitle("JOIN GROUP", forState: .Normal)
            print("Unjoin")
        }
    }
    
    //MARK: Join or unjoin group
    func joinGroup() {
        // get the group info on the
        guard let groupID = currentGroup?.groupID, userID = FIRAuth.auth()?.currentUser?.uid else { return }
        let groupRef = groupsRef.child("groups/\(groupID)/groupMembers/\(userID)")
        groupRef.setValue(true)
    }
    
    func unJoinGroup() {
        guard let groupID = currentGroup?.groupID, userID = FIRAuth.auth()?.currentUser?.uid else { return }
        let groupRef = groupsRef.child("groups/\(groupID)/groupMembers/\(userID)")
        groupRef.removeValue()
        
    }
    
    //MARK: Fetch group
    func fetchGroups() {
        let groupRef = groupsRef.child("/groups/groupID/groupMembers")
        groupRef.observeSingleEventOfType(.Value) { (groupSnapshot: FIRDataSnapshot) in
            
            self.currentGroup = Group(groupSnapshot: groupSnapshot)
        }
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        ref = FIRDatabase.database().reference()
        groupsRef = ref

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let thisGroup = currentGroup {
            groupNameLabel.text = thisGroup.groupName
            groupDescription.text = thisGroup.groupDescription
        }
        if let groupImageUrl = currentGroup?.groupImageUrl {
            groupImageView.loadImageUsingCacheWithUrlString(groupImageUrl)
        }
    }
    
}

//MARK: UITableViewDataSource
extension ActiveGroupViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("displayFriends", forIndexPath: indexPath) as! ActiveGroupTableViewCell
        return cell
    }
}

















