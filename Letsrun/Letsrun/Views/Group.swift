//
//  Group.swift
//  Letsrun
//
//  Created by Edrick Pascual on 7/26/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import UIKit
import Firebase

class Group: NSObject {
    
    var groupName: String?
    var groupSettings: String?
    var groupDescription: String?
    var groupImageUrl: String?
    var groupMembers: [String:Bool]?
    var groupID: String?
    var groupAdmin: String?
    
    
    init(groupSnapshot: FIRDataSnapshot) {
        if groupSnapshot.exists() {
            if let groupInfo = groupSnapshot.value as? [String:AnyObject] {
                self.groupID = groupSnapshot.key
                self.groupAdmin = groupInfo["groupAdmin"] as? String
                self.groupName = groupInfo["groupName"] as? String
                self.groupDescription = groupInfo["groupDescription"] as? String
                self.groupSettings = groupInfo["groupSettings"] as? String
                self.groupMembers = groupInfo["groupMembers"] as? [String:Bool]
                self.groupImageUrl = groupInfo["groupImageUrl"] as? String
            }
        }
    }

}
