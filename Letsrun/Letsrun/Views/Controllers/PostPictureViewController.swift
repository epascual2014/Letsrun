//
//  PostPictureViewController.swift
//  Letsrun
//
//  Created by Edrick Pascual on 8/11/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import UIKit
import Firebase

class PostPictureViewController: UIViewController {
    
    @IBOutlet weak var previewImageview: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var addImageview: CircleView!
    
    
    var photoTakingHelper: PhotoTakingHelper!
    
    var currentUsername = ""
    var currentUserImage = ""
    
    
    @IBAction func postPicture(sender: UIButton) {
        saveImagePosted()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addImageTapped(sender: AnyObject) {
        takePhoto()
    }
    
    // MARK: Take photo
    func takePhoto() {
        photoTakingHelper = PhotoTakingHelper(viewController: self) {
            (image: UIImage?) in
            self.previewImageview.image = image
            print("ED:--> taking photo")
        }
    }
    
    // MARK: Saves Image with the NSUUID and converts image to a metadata
    func saveImagePosted() {
        guard let image = previewImageview.image else {
            print("ED: --> Please select an image")
            return
        }
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            let imageUid = NSUUID().UUIDString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataSource.dataSource.REF_POST_IMAGES.child(imageUid).putData(imageData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("ED: Unable to upload image to FIR Storage")
                    
                } else {
                    print("ED: Succussfully uploaded to FIR Storage")
                    
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    if let url = downloadUrl {
                        self.postToFirebase(url)
                    }
                }
            }
        }
    }
    
    func postToFirebase(imageUrl: String) {
        let newPost: [String:AnyObject] = ["comments": commentTextField.text!,
                                           "imageUrl": imageUrl,
//                                           "profileImageUrl": currentUsername,
                                           "likes": 0,
                                           "loginName": currentUsername]
        DataSource.dataSource.createNewPost(newPost)
    }
    
    // MARK: Fetch current user
    func fetchUser() {
        guard let userID = FIRAuth.auth()?.currentUser?.uid else {
            return }
        DataSource.dataSource.REF_USERS.child(userID).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            print("ED: Snapshot ---> \(snapshot)")
            let username = snapshot.value!["loginName"] as! String
//            let profileImage = snapshot.value!["profileImageUrl"] as! String
//            self.currentUserImage = profileImage
            self.currentUsername = username
        })
    }
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        
    }
    
}
