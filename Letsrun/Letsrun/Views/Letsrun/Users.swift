//
//  Users.swift
//  Letsrun
//
//  Created by Edrick Pascual on 7/25/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import UIKit
import Firebase

class Users: NSObject {
    
    var uid: String?
    var loginName: String?
    var email: String?
    var imageProfileUrl: String?
    var city: String?
    var state: String?
    var shoe: String?
    var runnerType: Int?
//    var gender: Int!?
//    var age: Int?
    
    
    init(userID: String, userInfo: [String:AnyObject]) {
        self.uid = userID
        self.loginName = userInfo["loginName"] as? String
        self.email = userInfo["email"] as? String
        self.city = userInfo["city"] as? String
        self.state = userInfo["state"] as? String
        self.shoe = userInfo["shoe"] as? String
        self.runnerType = userInfo["runnerType"] as? Int
//        self.gender = userInfo["gender"] as? Int
//        self.age = userInfo["age"] as? Int
        self.imageProfileUrl = userInfo["profileImageUrl"] as? String

    }
    
    init(userSnapshot: FIRDataSnapshot){
        if userSnapshot.exists() {
            if let userInfo = userSnapshot.value as? [String:AnyObject] {
                self.uid = userSnapshot.key
                self.loginName = userInfo["loginName"] as? String
                self.email = userInfo["email"] as? String
                self.city = userInfo["city"] as? String
                self.state = userInfo["state"] as? String
                self.shoe = userInfo["shoe"] as? String
                self.runnerType = userInfo["runnerType"] as? Int
//                self.gender = userInfo["gender"] as? Int
//                self.age = userInfo["age"] as? Int
                
                if let imageProfileUrl = userInfo["profileImageUrl"] as? String {
                    self.imageProfileUrl = imageProfileUrl
                } else {
                    self.imageProfileUrl = "no image"
                }
            }
        }
    }
    
}

