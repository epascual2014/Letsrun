//
//  CreateUserViewController.swift
//  Letsrun
//
//  Created by Edrick Pascual on 7/13/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import UIKit
import Firebase

enum RunnerType: Int {
    case Road = 0
    case Trail = 1
    case Both = 2
}

enum Gender: Int {
    case Female = 0
    case Make = 1
}

enum PickerComponent: Int {
    case city = 0
    case state = 1
}

class CreateUserViewController: UIViewController {
    
    // Reference to Firebase Database
    let ref = FIRDatabase.database().reference()
    
    // Reference Firebase Storage
    let storageRef = FIRStorage.storage().reference()
    
    // Firebase storage metadata
    var metadata = FIRStorageMetadata()

    
    var userCredentialInfo = [String: String]()
    var photoTakingHelper: PhotoTakingHelper?
    
    @IBOutlet weak var userPictureImageView: UIImageView!
    @IBOutlet weak var loginNameTextfield: UITextField!
    @IBOutlet weak var ageTextfield: UITextField!
    @IBOutlet weak var shoebrandTextfield: UITextField!
    
    @IBOutlet weak var cityTextfield: UITextField!
    @IBOutlet weak var stateTextfield: UITextField!
    
    @IBOutlet weak var runnerTypeSegementControl: UISegmentedControl!
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    
    // Button to take photo function
    @IBAction func cameraTappedButton(sender: AnyObject) {
        takePhoto()
    }
    
    //MARK: Take photo method
    func takePhoto() {
        // Instantiate photo taking class, provide callback for when photo is selected
        photoTakingHelper = PhotoTakingHelper(viewController: self) {
            (image: UIImage?) in
            self.userPictureImageView.image = image
            
            print("received a callback")
        }
    }
    
    //MARK: User is created here.
    func createUser(completion: (user: FIRUser?) -> Void) {
        guard let userEmail = userCredentialInfo["email"],
                    userPassword = userCredentialInfo["password"],
                    userName = self.loginNameTextfield.text,
                    userAge = self.ageTextfield.text,
                    userShoe = self.shoebrandTextfield.text else {
            return
        }
        
        FIRAuth.auth()?.createUserWithEmail(userEmail, password: userPassword) { user, error in
            if error != nil {
                print(error)
            } else if let user = user {
                self.userCredentialInfo["loginName"] = userName
                self.userCredentialInfo["age"] = userAge
                self.userCredentialInfo["shoe"] = userShoe
                self.userCredentialInfo["gender"] = "\(self.genderSegmentControl.selectedSegmentIndex)"
                self.userCredentialInfo["runnerType"] = "\(self.runnerTypeSegementControl.selectedSegmentIndex)"
                
                // calls savesindatabaseuser function
                self.saveInDatabaseUser(user.uid, userDatabaseRef: self.userCredentialInfo)
                completion(user: user)
                print(#function,"USER CREATED: \(user.uid)\n")
            }
        }
    }
    
    //MARK: Saves user info in Firebase database
    func saveInDatabaseUser(userID: String, userDatabaseRef: [String:String]) {
        // Reference to Firebase database child
        let usersReference = ref.child("users").child(userID)        
        usersReference.setValue(userDatabaseRef) { (error: NSError?, ref: FIRDatabaseReference) in
            if error != nil {
                print(error)
            } else {
                print(userDatabaseRef)
                self.saveUserImage(userID)
            }
        }
    }

    //MARK: Saves user image in Firebase storage
    func saveUserImage(userID: String) {
        // Referance Firebase Storage Root Folder
        let imageName = NSUUID().UUIDString
        let userImageRef = storageRef.child("userImages").child("\(imageName).jpg")
        
        guard let image = self.userPictureImageView.image, data = UIImageJPEGRepresentation(image, 0.5) else {
            return
        }
        
        // Puts data in Firebase Storage
        userImageRef.putData(data, metadata: metadata) { (metadata, error) in
            if (error != nil) {
                print(error)
                return
            }
            
            if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                self.ref.child("users").child(userID).child("profileImageUrl").setValue(profileImageUrl)
            }
            
            print(metadata)
        }
    }
    
   var runnerType = ""
    
    @IBAction func runnerSegementedTapped(sender: UISegmentedControl) {
        
        switch  RunnerType(rawValue: sender.selectedSegmentIndex)! {
        case .Road:
            runnerType = "Road"
        case .Trail:
            runnerType = "Trail"
        case .Both:
            runnerType = "Both"
        }
        print(#function)
    }
    
    //MARK Register button IBAction function
    @IBAction func registerTappedButton(sender: UIButton) {
    
        print(#function)
        createUser() { (user) in
            if user != nil {
                print("registered")
                self.performSegueWithIdentifier("presentMainTabController", sender: nil)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}




