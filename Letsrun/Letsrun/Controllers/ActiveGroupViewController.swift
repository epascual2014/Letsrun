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
    
    let firebaseHelper = FirebaseHelper()
    
    var currentGroup = Group?()
    
    
    //Checking whether current user is a group member.
    var groupMember = [String:Bool]() {
        didSet {
            let thisUser = groupMember.contains { $0.0 == FIRAuth.auth()?.currentUser?.uid }
            if thisUser {
                trueUser = true
            } else {
                trueUser = false
            }
        }
    }
    
    var groupUsers = [String:String]()
    
    var ref: FIRDatabaseReference!
    //var groupsRef: FIRDatabaseReference!
    var trueUser = false
    
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupDescription: UITextView!

    // Button label and action
   
    @IBOutlet weak var joinGroupButton: UIButton!
    
    @IBAction func joinOrUnjoinTapped(sender: UIButton) {
        if joinGroupButton.titleLabel?.text == "LEAVE GROUP" {
            joinGroupButton.setTitle("JOIN GROUP", forState: .Normal)
            leaveGroup()
        } else {
            joinGroupButton.setTitle("LEAVE GROUP", forState: .Normal)
            joinGroup()
        }
    }
    
    //MARK: Join Group
    func joinGroup() {
        // get the group info on the
        guard let groupID = currentGroup?.groupID, userID = FIRAuth.auth()?.currentUser?.uid else { return }
        let groupRef = ref.child("groups/\(groupID)/groupMembers/\(userID)")
        groupRef.setValue(true)
        print(#function, groupRef)
    }
    
    //MARK: Leave group
    func leaveGroup() {
        guard let groupID = currentGroup?.groupID, userID = FIRAuth.auth()?.currentUser?.uid else { return }
        let groupRef = ref.child("groups/\(groupID)/groupMembers/\(userID)")
        groupRef.removeValue()
        
    }
    
    //MARK: Fetch group data
    func fetchGroups(completion: ((thisGroup: Group) -> Void)?) {
            let groupRef = ref.child("groups")
        
        groupRef.observeSingleEventOfType(.Value) { (groupSnapshot: FIRDataSnapshot) in
                if groupSnapshot.exists() {
                    for groupSnap in groupSnapshot.children {
                        let group = Group(groupSnapshot: (groupSnap as! FIRDataSnapshot))
                        
                        let thisGroup = group
                        print(#function, thisGroup.groupMembers)
                        completion?(thisGroup: group)
                    }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        fetchGroups { (thisGroup: Group) -> Void in
            thisGroup
            
            self.groupMember = thisGroup.groupMembers!
            let isMember = self.groupMember.contains {$0.0 == FIRAuth.auth()?.currentUser?.uid}
            if isMember {
                // Set leave group button
                dispatch_async(dispatch_get_main_queue(), { 
                    self.joinGroupButton.setTitle("LEAVE GROUP", forState: .Normal)
//                    self.createRunButton.hidden = false 
                })
            }
        }
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
    
    //MARK: Prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "groupMemberSegue" {
                
                print("Table View cell tapped")
                
                let displayActiveGroupViewController = segue.destinationViewController as! GroupMembersViewController
                displayActiveGroupViewController.currentGroupKey = currentGroup?.groupID
                
                print("Pass the data to the ActiveViewController")
                
            } else if identifier == "groupEdit" {
                
                let displayActiveGroupViewController = segue.destinationViewController as! CreateEventViewController
                displayActiveGroupViewController.currentGroupKey = currentGroup?.groupID
        
            }
        }
    }
}


















