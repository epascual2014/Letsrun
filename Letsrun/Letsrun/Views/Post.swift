//
//  Post.swift
//  Letsrun
//
//  Created by Edrick Pascual on 8/9/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    private var _postRef: FIRDatabaseReference!
    private var _postKey: String!
    private var _postComments: String!
    private var _postLikes: Int!
    private var _postUsername: String!
    private var _postImageUrl: String!

    
    var postKey: String {
        return _postKey
    }
    
    var postComments: String {
        return _postComments
    }
    
    var postLikes: Int {
        return _postLikes
    }
    
    var postUsername: String {
        return _postUsername
    }
    
    
    var postImageUrl: String! {
        return _postImageUrl
    }
    
    
    init(postComments: String, postLikes: Int, username: String, postImageUrl: String, postUserImageUrl: String) {
        self._postComments = postComments
        self._postLikes = postLikes
        self._postUsername = username
        self._postImageUrl = postImageUrl
        
    }
    
    // Pass data to Firebase
    init(postKey: String, postData: [String: AnyObject]) {
        self._postKey = postKey
        
        if let postComments = postData["comments"] as? String {
            self._postComments = postComments
        }
        
        if let postLikes = postData["likes"] as? Int {
            self._postLikes = postLikes
        }
        
        if let postUsername = postData["loginName"] as? String {
            self._postUsername = postUsername
        } else {
            self._postUsername = ""
        }
        
        if let postImageUrl = postData["imageUrl"] as? String{
            self._postImageUrl = postImageUrl
        }
        
        _postRef = DataSource.dataSource.REF_POSTS.child(self._postKey)
    }
    
    // Add or remove likes
    func likeAndUnlike(addLike: Bool) {
        if addLike {
            _postLikes = _postLikes + 1
        } else {
            _postLikes = _postLikes - 1
        }
        _postRef.child("likes").setValue(_postLikes)
    }
    
}
