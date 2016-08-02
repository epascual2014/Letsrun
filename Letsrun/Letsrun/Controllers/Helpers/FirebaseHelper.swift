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
    // Current invites
    case GroupInvitations = "invtiations"
    
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
    
    //MARK: Save data to Firebase
    func saveData(data: Groups, toRefPoint refPoint: ReferencePoint) {
        
        guard let data = data as? FirebaseConvertInfo else {
            //            ErrorHandling.defaultErrorHandler(NSError(domain: "Error", code: 1, userInfo:
            //                [NSLocalizedDescriptionKey: "Sorry data is not compatible with FirebaseConvertible protocol"]))
            return
        }
        
        switch refPoint {
        case .Users:
            saveToUsers(data)
        case .Groups:
            saveToGroups(data)
        case .GroupInvitations:
            saveToInvitations(data)
        }
    }
    
    
    
    
    private func saveToUsers(data: FirebaseConvertInfo) {
        FirebaseHelper._rootRef.child(ReferencePoint.Users.rawValue).childByAutoId().setValue(data.convertToFirebase()) { (error: NSError?, dataRef: FIRDatabaseReference) in
            if error != nil {
                // ErrorHandling.defaultErrorHandler(error!)
                
            }
        }
    }
    
    
    private func saveToGroups(data: FirebaseConvertInfo) {
        FirebaseHelper.rootRef.child(ReferencePoint.Groups.rawValue).childByAutoId().setValue(data.convertToFirebase()) { (error: NSError?, dataRef: FIRDatabaseReference) in
            if error != nil {
                //  ErrorHandling.defaultErrorHandler(error!)
            }
        }
    }
    
    private func saveToInvitations(data: FirebaseConvertInfo) {
        FirebaseHelper.rootRef.child(ReferencePoint.GroupInvitations.rawValue).childByAutoId().setValue(data.convertToFirebase()) { (error: NSError?, dataRef: FIRDatabaseReference) in
            if error != nil {
                //  ErrorHandling.defaultErrorHandler(error!)
            }
        }
    }
    
    
    //MARK: Firebase observers - keep data uptodate on the apps screen with Firebase.
    /// Add a continous observer for the values
    func addValueObserverForRefPoint(refPoint: ReferencePoint, completion: (FIRDataSnapshot) -> Void) {
        FirebaseHelper._rootRef.child(refPoint.rawValue).observeEventType(.Value, withBlock: completion)
    }
    
    func addValueObserverForCustomReferencePoint(customRefPoint: String, completion: (FIRDataSnapshot) -> Void) {
        FirebaseHelper._rootRef.child(customRefPoint).observeEventType(.Value, withBlock: completion)
    }
    
    /// Add Firebase observer for a SINGLE EVENT
    func addSingleObserverForRefPoint(refPoint:ReferencePoint, completion: (FIRDataSnapshot) -> Void) {
        FirebaseHelper._rootRef.child(refPoint.rawValue).observeEventType(.Value, withBlock: completion)
    }
    
    /// Remove Firebase Observer
    func removeObserverForRefPoint(refPoint:ReferencePoint) {
        FirebaseHelper.rootRef.child(refPoint.rawValue).removeAllObservers()
    }
}