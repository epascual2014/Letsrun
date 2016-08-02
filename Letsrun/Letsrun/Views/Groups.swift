//
//  grps.swift
//  Letsrun
//
//  Created by Edrick Pascual on 7/18/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import Foundation
import Firebase

struct Groups: LetsRunType, FirebaseConvertInfo{
    
    let groupName: String
    let groupCity: String
    let groupFrequency: String
    let groupLevel: String
    let groupPrivacy: String
    let groupImageUrl: String
    

    init(info:[String: AnyObject]) {
        self.groupName = info["groupName"] as! String
        self.groupCity = info["groupCity"] as! String
        self.groupFrequency = info["groupFrequency"] as! String
        self.groupLevel = info["groupLevel"] as! String
        self.groupPrivacy = info["groupPrivacy"] as! String
        if let groupImageUrl = info["groupImageUrl"] as? String {
            self.groupImageUrl = groupImageUrl
        } else {
            self.groupImageUrl = "no image"
        }
        
    }
    
    func convertToFirebase() -> [String : AnyObject] {
        var firebaseInfo = [String: AnyObject]()
        firebaseInfo["groupName"] = self.groupName
        firebaseInfo["groupCity"] = self.groupCity
        firebaseInfo["groupPrivacy"] = self.groupPrivacy
        firebaseInfo["groupImageUrl"] = self.groupImageUrl
        
        return firebaseInfo
        
    }
    
}
