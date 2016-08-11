//
//  Event.swift
//  Letsrun
//
//  Created by Edrick Pascual on 8/5/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import UIKit
import Firebase

class Event: NSObject {
    
    var eventName: String?
    var location: String?
    var time: String?
    var period: String?
    var distance: String?
    var eventID: String?
    
    
    init(eventSnapshot: FIRDataSnapshot) {
        if eventSnapshot.exists() {
            if let eventInfo = eventSnapshot.value as? [String:AnyObject] {
                self.eventID = eventSnapshot.key
                self.eventName = eventInfo["groupAdmin"] as? String
                self.location = eventInfo["groupName"] as? String
                self.time = eventInfo["groupDescription"] as? String
                self.period = eventInfo["groupSettings"] as? String
                self.distance = eventInfo["distance"] as? String
            }
        }
    }


}
