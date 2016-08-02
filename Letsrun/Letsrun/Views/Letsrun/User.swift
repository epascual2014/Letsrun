//
//  User.swift
//  Letsrun
//
//  Created by Edrick Pascual on 7/15/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import Foundation
import Firebase

class User: NSObject {
    
    var email: String
    var loginName: String
    var age: Int
    var userCity: String
    var userState: String
    var shoeBrand: String
    var runnerType: String
    let imgUrl: String
    let userID: String
    
    //    init(info: [String: AnyObject]) {
    //        self.init(userID: "", info: info)
    //    }
    
    
    init(userID: String, info: [String: AnyObject]) {
            self.userID = userID
            self.email = info["email"] as! String ?? "no entry"
            self.loginName = info["loginName"] as? String ?? "no entry"
            self.age = info["age"] as? Int ?? 0
            self.userCity = info["userCity"] as? String ?? "no entry"
            self.userState = info ["userState"] as? String ?? "no entry"
            self.shoeBrand = info["shoeBrand"] as? String ?? "no entry"
            self.runnerType = info["runnerType"] as? String ?? "no entry"
            
            if let imgUrl = info["imgUrl"] as? String {
                self.imgUrl = imgUrl
            } else {
                self.imgUrl = "no image"
            }
    }
    //
    //    func convertToFirebase() -> [String:AnyObject] {
    //        var firebaseInfo = [String:AnyObject]()
    //        firebaseInfo["loginName"] = self.loginName
    //        firebaseInfo["age"] = self.age
    //        firebaseInfo["email"] = self.email
    //        firebaseInfo["userCity"] = self.userCity
    //        firebaseInfo["userState"] = self.userState
    //        firebaseInfo["shoeBrand"] = self.shoeBrand
    //        firebaseInfo["runnerType"] = self.runnerType
    //        firebaseInfo["imgUrl"] = self.imgUrl
    //        return firebaseInfo
    //    }
    //    
}
