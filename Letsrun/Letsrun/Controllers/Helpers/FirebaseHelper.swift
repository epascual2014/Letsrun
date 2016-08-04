//
//  FirebaseHelper.swift
//  Letsrun
//
//  Created by Edrick Pascual on 7/15/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import Firebase

protocol FirebaseConvertInfo {
    func convertToFirebase() -> [String: AnyObject]
    
}

enum ReferencePoint: String {
    // Current users
    case Users = "users"
    // Active groups
    case Groups = "groups"
    
}

class FirebaseHelper {
    
    private static var _rootRef = FIRDatabase.database().reference()
    static var rootRef: FIRDatabaseReference {
        return _rootRef
    }
    
    init() {
        
    }
    
    // MARK: Firebase user signup and login
    func loginWithEmail(email: String, password: String, completion: (user: FIRUser?) -> Void) {
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user: FIRUser?, error: NSError?) in
            
            if error != nil {
                print("incorrect")
                return
            } else {
                completion(user: user)
            }
        })
    }
    
    //    func createUserWithEmail(email: String, password: String) {
    //        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user: FIRUser?, error: NSError?) in
    //            if error != nil {
    //                //ErrorHanding.defaultErrorhandler(error!)
    //            } else if user != nil {
    //                self.loginWithEmail(email, password: password)
    //            }
    //
    //        })
    //    }
    
}