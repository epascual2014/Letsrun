//
//  UserProfileViewController.swift
//  Letsrun
//
//  Created by Edrick Pascual on 8/1/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var loginNameLabel: UILabel!
    @IBOutlet weak var userCityLabel: UILabel!
    @IBOutlet weak var userStateLabel: UILabel!
    
    
    var thisUser = Users?()
    
    // This is where the variable is declared
    var ref: FIRDatabaseReference!
    var groupsReference: FIRDatabaseReference!
    
    //MARK: Fetchuser
    func fetchUser(user: String) {
        let userRef = ref.child("users").child(user)
        userRef.observeSingleEventOfType(.Value) { (userSnapshot: FIRDataSnapshot) in
            print(userSnapshot)
            
            // Use self since its inside the function and intialized
            self.thisUser = Users(userSnapshot: userSnapshot)
            
            // Assign labels to properties of the Model
            self.userEmailLabel.text = self.thisUser?.email
            self.loginNameLabel.text = self.thisUser?.loginName
            
            if let userImageUrl = self.thisUser?.imageProfileUrl {
                self.userImageView.loadImageUsingCacheWithUrlString(userImageUrl)
            }
//            self.userCityLabel.text = self.thisUser?.city
//            self.userStateLabel.text = self.thisUser?.state
        }
    }

    //MARK: Fetch Image from Firebase storage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This is where is the variable initialized.
        ref = FIRDatabase.database().reference()

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser((FIRAuth.auth()?.currentUser!.uid)!)
    
    }


}
