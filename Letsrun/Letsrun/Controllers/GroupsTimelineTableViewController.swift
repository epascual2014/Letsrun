//
//  GroupsTimelineTableViewController.swift
//  Letsrun
//
//  Created by Edrick Pascual on 7/19/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import UIKit
import Firebase
class GroupsTimelineTableViewController: UITableViewController {
    
    // Firebase reference
    var ref: FIRDatabaseReference!
    var groupsReference: FIRDatabaseReference!
    
    // Array of users from model class
    var groupArray = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Database Referance
        ref = FIRDatabase.database().reference()
        groupsReference = ref.child("groups")
        
        if FIRAuth.auth()?.currentUser == nil {
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            presentViewController(loginViewController, animated: true, completion: nil)
        }
    }
    
    //MARK: Calling Firebase Database
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        fetchGroups()
    }
    
    //MARK: Fetch groups in an array from FIREBASE
    func fetchGroups(){
        let groupRef = FIRDatabase.database().reference().child("groups")
        groupRef.observeEventType(.Value) { (groupSnapshot: FIRDataSnapshot) in
            
            self.groupArray.removeAll()
            for groupSnap in groupSnapshot.children {
                let group = Group(groupSnapshot: (groupSnap as! FIRDataSnapshot))

                // Adds value to the group
                self.groupArray.append(group)
                self.tableView.reloadData()
                print(#function, group.groupMembers)
            }
        }
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        // Removes obeserver so everytime user moves to a different view the
        // app does not keep a constant connection with Firebase.
        groupsReference.removeAllObservers()
    }


    // MARK: - TableViews
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groupArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // Dequeue cell
        let cell  = tableView.dequeueReusableCellWithIdentifier("displayGroups", forIndexPath: indexPath) as! TimelineTableViewCell
        
        let group = groupArray[indexPath.row]
        cell.groupNameLabel.text = group.groupName
        
        if let groupImageUrl = group.groupImageUrl {
            cell.groupImageView.loadImageUsingCacheWithUrlString(groupImageUrl)
        }

        print(cell.groupImageView)
        return cell
    }
 
    //MARK: Prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "showGroupDetails" {
                
                print("Table View cell tapped")
                let indexPath = tableView.indexPathForSelectedRow!
    
                let currentGroup = groupArray[indexPath.row]
                
                let displayActiveGroupViewController = segue.destinationViewController as! ActiveGroupViewController
                
                displayActiveGroupViewController.currentGroup = currentGroup
                
                print("Pass the data to the ActiveViewController")
                print(currentGroup)
                
            } else {
                print("nothing")
            }
        }
    }
    
    @IBAction func unwindToActiveGroupInfoViewController(segue: UIStoryboardSegue) {
        
    }

    @IBAction func unwindToCreateGroupInfoViewController(segue: UIStoryboardSegue) {
        
    }
}

extension GroupsTimelineTableViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        
    }
    
    
}

