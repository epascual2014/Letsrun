//
//  UserInfoViewController.swift
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

class UserInfoViewController: UIViewController {
    
    var userCredentialInfo: [String: String]?
    var photoTakingHelper: PhotoTakingHelper?

    @IBOutlet weak var userPictureImageView: UIImageView!
    @IBOutlet weak var loginNameTextfield: UITextField!
    @IBOutlet weak var ageTextfield: UITextField!
    @IBOutlet weak var cityTextfield: UITextField!
    @IBOutlet weak var stateTextfield: UITextField!
    @IBOutlet weak var genderTextfield: UITextField!
    @IBOutlet weak var shoebrandTextfield: UITextField!
    @IBOutlet weak var cameraBoxButton: UIButton!
    @IBOutlet weak var runnerTypeSegementControl: UISegmentedControl!
    
    @IBAction func cameraTappedButton(sender: AnyObject) {
        // Take photo method
        func takePhoto() {
            // Instantiate photo taking class, provide callback for when photo is selected
            photoTakingHelper = PhotoTakingHelper(viewController: self) {
                (image: UIImage?) in
                self.userPictureImageView.image = image
                self.cameraBoxButton.hidden = true
                
                print("received a callback")
            }
        }
        takePhoto()
    }
    
    
    func createUser(userCredentialInfo: [String:String]) {
        guard let email = userCredentialInfo["email"], password = userCredentialInfo["password"] else { return }
        FIRAuth.auth()?.createUserWithEmail(email, password: password) { user, error in
            if error != nil {
                print(error)
            } else if let user = user {
                    var userInfo = userCredentialInfo
                    userInfo["userImage"] = "\(self.userPictureImageView.image)"
                    userInfo["loginName"] = self.loginNameTextfield.text
                    userInfo["gender"] = self.genderTextfield.text
                    userInfo["age"] = self.ageTextfield.text
                    userInfo["city"] = self.cityTextfield.text
                    userInfo["shoe"] = self.shoebrandTextfield.text
                    userInfo["runnertype"] = "\(self.runnerTypeSegementControl.selectedSegmentIndex)"
                    print(#function,"User created \(user.uid)\n",userInfo)
                    
                    self.saveInDatabaseUser(user.uid, userDatabaseRef: userInfo)
            }
        }
        
    }
    
    func saveInDatabaseUser(userUID: String, userDatabaseRef: [String:String]) {
        print(#function, userDatabaseRef)
        // Reference to Firebase database
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").child(userUID).setValue(userDatabaseRef) { (error: NSError?, userDatabaseRef: FIRDatabaseReference) in
            if error != nil {
                print(error)
            } else {
                print(userDatabaseRef)
            }
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
    
    @IBAction func registerTappedButton(sender: UIButton) {
    
        guard let userCredentialInfo = userCredentialInfo else {
            return
        }
        
        createUser(userCredentialInfo)
        print("registered")
        performSegueWithIdentifier("presentTabController", sender: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
