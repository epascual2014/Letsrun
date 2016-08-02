//
//  Tweets.swift
//  Letsrun
//
//  Created by Edrick Pascual on 7/21/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Tweets {
    
    let key: String!
    let content: String!
    let addedByUser: String!
    let itemRef: FIRDatabaseReference?
    
    init(content: String, addedByUser: String, key: String = "") {
        self.key = key
        self.content = content
        self.addedByUser = addedByUser
        self.itemRef = nil
    }
    
    init(snapshot:FIRDataSnapshot) {
        key = snapshot.key
        itemRef = snapshot.ref
        
        if let tweetContent = snapshot.value!["content"] as? String {
            content = tweetContent
        } else {
            content = ""
        }
        
        if let tweetUser = snapshot.value!["addedByUser"] as? String {
            addedByUser = tweetUser
        } else {
            addedByUser = ""
        }
        
    }
    
    func toAnyObject() -> AnyObject {
        return ["content": content, "addedByUser": addedByUser]
    }
    
}
