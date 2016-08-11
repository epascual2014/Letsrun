//
//  CreateEventViewController.swift
//  Letsrun
//
//  Created by Edrick Pascual on 8/5/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import UIKit
import Firebase

class CreateEventViewController: UIViewController {
    
    
    @IBOutlet weak var eventNameTextfield: UITextField!
    
    
    var currentGroupKey: String?
    
    // Reference to Firebase Database
    let ref = FIRDatabase.database().reference()

    var eventInfo = [String: AnyObject]()

//    func fetchGroupKey(key: String) {
//        ref.child("groups/\(key)").observeSingleEventOfType(.Value) { (eventSnapshot: FIRDataSnapshot) .initialize()
//            
//            if eventSnapshot.exists() {
//                for (eventKey, _) snapshot.value as! [String: AnyObject] {
//                    self.ref.child("users/\(eventKey)").observeSingleEventOf
//                }
//                
//            }
//        
//    }
    
    
    // MARK: Create Event
    func createEvent(){
        let userID = FIRAuth.auth()?.currentUser?.uid
        let groupRef = ref.child("groups")
        
        guard let eventName = self.eventNameTextfield.text else {
            return
        }
        if let user = userID {
            eventInfo["eventName"] = eventName
        }
        
        groupRef.updateChildValues(eventInfo) { (error: NSError?, groupRef: FIRDatabaseReference) in
            if error != nil {
                print(error)
            } else {
            
            }
        }
    }
    
    @IBAction func saveEventTapped(sender: AnyObject) {
        createEvent()
        print(eventInfo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
