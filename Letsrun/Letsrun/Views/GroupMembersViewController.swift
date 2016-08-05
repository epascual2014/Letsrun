//
//  GroupMembersViewController.swift
//  Letsrun
//
//  Created by Edrick Pascual on 8/4/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import UIKit
import Firebase

class GroupMembersViewController: UIViewController {

    @IBOutlet weak var groupCollectionView: UICollectionView!
    
    // Firebase reference
    var ref: FIRDatabaseReference!
    var groupsReference: FIRDatabaseReference!
    
    // Create a reference from ActiveGroupControllers and telling swift what type  it is - String type
    var currentGroupKey: String?
    var groupMembers = [Users]() {
        didSet {
            groupCollectionView.reloadData()
        }
    }
    var thisGroup = ""
    
        override func viewDidLoad() {
        super.viewDidLoad()
        
        // Database Referance
        ref = FIRDatabase.database().reference()

        fetchGroupMembersForKey(currentGroupKey!)
    }

    func fetchGroupMembersForKey(key: String) {
        ref.child("groups/\(key)/groupMembers").observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
            
            // check if snapshot exists
            if snapshot.exists() {
                
                // Interates the group members list and grabs user Key and fetching user information from FIREBASE
                for (userKey, _) in snapshot.value as! [String: AnyObject] {
                    self.ref.child("users/\(userKey)").observeSingleEventOfType(.Value, withBlock: { (userSnapshot: FIRDataSnapshot) in
                        
                        // assigns user to the Users moder.
                        let user = Users(userSnapshot: userSnapshot)
                        
                        // Adds member to the groupMember array
                        self.groupMembers.append(user)
                    })
                }
            }
        }
    }
    
    
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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

extension GroupMembersViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupMembers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("displayMembers", forIndexPath: indexPath) as! GroupMemberCollectionViewCell
       
        let user = groupMembers[indexPath.row]
        
        cell.groupNameLabel.text = user.loginName
        
        if let userImageProfileUrl = user.imageProfileUrl {
            cell.groupImageView.loadImageUsingCacheWithUrlString(userImageProfileUrl)
        }
        
        return cell
    }
}
