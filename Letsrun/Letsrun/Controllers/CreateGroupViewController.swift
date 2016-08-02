//
//  CreateGroupViewController.swift
//  Letsrun
//
//  Created by Edrick Pascual on 7/12/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import UIKit
import Firebase

enum GroupPrivacy: Int {
    case Public = 0
    case Private = 1
}

enum GroupPrivacyNew: String {
    case Public = "Public"
    case Private = "Private"
}

class CreateGroupViewController: UIViewController {
    
    // Reference to Firebase Database
    let ref = FIRDatabase.database().reference()
    
    // Reference to Firebase Storage
    let storageReference = FIRStorage.storage().reference()
    
    // Firebase storage metadata
    var metadata = FIRStorageMetadata()
    
    // Call Phototakinghelper class
    var photoTakingHelper: PhotoTakingHelper?
    
    var groupCredentialInfo = [String:AnyObject]()
    var userGroupCredentialInfo:[String: AnyObject]?
    var groupDictionary = [String:AnyObject]()
    
    
    //MARK: Save group information
    @IBAction func saveGroupTapped(sender: AnyObject) {
        createGroup()
    }
    
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameTextfield: UITextField!
    
    
    // Box on top of image to have user ability to chose an image.
    @IBOutlet weak var selectImageBox: UIButton!
    @IBOutlet weak var groupDescriptionTextview: UITextView!
    @IBOutlet weak var groupPrivacySegmentedControl: UISegmentedControl!
    
    
    //MARK:-Segemented Control Index
    var groupPrivacy = GroupPrivacyNew.Private
    
    // Select privacy settings for the group
    @IBAction func groupPrivacySegmentTapped(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            groupPrivacy = .Public
        case 1:
            groupPrivacy = .Private
        default:
            break
        }
        print(#function)
    }
    
    func createGroup() {
        let groupID = ref.childByAutoId().key
        let userID = FIRAuth.auth()?.currentUser?.uid
        let groupReference = ref.child("groups").child(groupID)

        guard let groupName = self.groupNameTextfield.text,
            groupDescription = self.groupDescriptionTextview.text else {
                return
        }
        if let user = userID {
            groupDictionary["groupAdmin"] = userID
            groupDictionary["groupDescription"] = groupDescription
            groupDictionary["groupName"] = groupName
            groupDictionary["groupMembers"] = [user: true]
            groupDictionary["groupSettings"] = groupPrivacy.rawValue
            

        }
        
        groupReference.updateChildValues(groupDictionary) { (error: NSError?, groupRef: FIRDatabaseReference) in
            if error != nil {
                print(error)
            } else {
                self.saveGroupImg(groupID)
            }
        }
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    //MARK: Make group creator as a member
//    func joinGroup() {
//        let groupID = ref.childByAutoId().key
//        let groupReference = ref.child("groups").child(groupID)
//        
//        // get the group info on the
//        guard let userID = FIRAuth.auth()?.currentUser?.uid else { return }
//        let groupRef = groupReference.child("groups/\(groupID)/groupMembers/\(userID)")
//        groupRef.setValue("isMember")
//    }
    
    //MARK: Saves into Firebase Database
    func saveInDatabase(groupID: String, groupDatabaseRef: [String:AnyObject]){
        let groupReference = ref.child("groups").child(groupID)
        groupReference.setValue(groupDatabaseRef) { (error: NSError?, ref: FIRDatabaseReference) in
            if error != nil {
                print(error)
            } else {
                print(groupDatabaseRef)
                // call save group image function
            }
        }
    }
    
    func groupAdmin() {

    }
    
    //MARK: Saves group image to Firebase storage
    func saveGroupImg(groupID: String) {
        let groupImageName = NSUUID().UUIDString
        let groupReference = storageReference.child("groupImages").child("\(groupImageName).jpg")
        
        guard let groupImage = self.groupImageView.image, data = UIImageJPEGRepresentation(groupImage, 0.5) else {
            return
        }
        
        groupReference.putData(data, metadata: metadata) { (metadata, error) in
            
            if (error != nil) {
                print(error)
                return
                
            }
            // save this to the group id / imgUrl set this url as the value
            if let groupUrl = metadata?.downloadURL()?.absoluteString {
                self.ref.child("groups").child(groupID).child("groupImageUrl").setValue(groupUrl)
            }
            print("group \(metadata)")
        }
    }
    
    @IBAction func inviteFriendsTapped(sender: AnyObject) {
        
        // Invite friends list view
        //performSegueWithIdentifier("inviteFriendsIdentifier", sender: nil)
        
    }
    
    @IBAction func selectImageBoxButton(sender: UIButton) {
        takePhoto()
    }
    
    func takePhoto() {
        photoTakingHelper = PhotoTakingHelper(viewController: self) {
            (image: UIImage?) in
            self.groupImageView.image = image
            self.selectImageBox.hidden = true
            print("received a callback")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
