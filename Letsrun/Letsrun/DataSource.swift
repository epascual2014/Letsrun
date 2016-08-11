//
//  DataSource.swift
//  Letsrun
//
//  Created by Edrick Pascual on 8/9/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//


import Foundation
import Firebase
import SwiftKeychainWrapper

// Firebase reference database
let _rootRef = FIRDatabase.database().reference()

// Firebase storage reference
let _storageRef = FIRStorage.storage().reference()

class DataSource {
    
    static let dataSource = DataSource()
    
    private var _REF_BASE = _rootRef
    private var _REF_POSTS = _rootRef.child("posts")
    private var _REF_USERS = _rootRef.child("users")
    private var _REF_GROUPS = _rootRef.child("groups")
    
    // Storage For profile images
    private var _REF_USERPROFILE_IMAGES = _storageRef.child("userProfile-pics")
    
    // Storage references
    private var _REF_POST_IMAGES = _storageRef.child("post-pics")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = KeychainWrapper.stringForKey(KEY_UID)
        let user = _REF_USERS.child(uid!)
        return user
    }
    
    var REF_USERPROFILE_IMAGES: FIRStorageReference {
        return _REF_USERPROFILE_IMAGES
    }

    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    // MARK: Functions to create a FIREBASE user
    func createFirebaseUser(uid: String, userData: [String: AnyObject]) {
        /* If there is a new user, Firebase creates an object.
         //If data doesnt exists, data is added otherwise if the data exists, do not overwrite and add data. */
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
    
    func createNewPost(post: [String:AnyObject]) {
        let firebaseNewPost = REF_POSTS.childByAutoId()
        firebaseNewPost.setValue(post)
        
    }
    
    
}

