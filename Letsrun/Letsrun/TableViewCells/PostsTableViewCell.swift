//
//  PostsTableViewCell.swift
//  Letsrun
//
//  Created by Edrick Pascual on 8/9/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import UIKit
import Firebase

class PostsTableViewCell: UITableViewCell {
    
    var post: Post!
    var likeRef: FIRDatabaseReference!

    // Labels and textview outlets
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    // Imageview outlets
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var heartImageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        heartImageview.addGestureRecognizer(tap)
        heartImageview.userInteractionEnabled = true
        
    }
    
    func configureCell(post: Post) {
        self.post = post
        self.commentLabel.text = post.postComments
        self.userNameLabel.text = post.postUsername
        self.likesLabel.text = "\(post.postLikes)"
        
        // Reference likes with the postKey ID from Firebase
        likeRef = DataSource.dataSource.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        // Observes once from Firebase for likes
        likeRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if (snapshot.exists()) {
                print("ED: Snapshot ---\(snapshot)")
                
                // Current user like or unlike post changes the icon image
                self.heartImageview.image = UIImage(named: "filled-heart")
            } else {
                self.heartImageview.image = UIImage(named: "empty-heart")
            }
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likeRef.observeSingleEventOfType(.Value, withBlock: { (snapshot: FIRDataSnapshot) in
            if let snapshot = snapshot.value as? NSNull {
                print("ED: \(snapshot)")
                
                //In Post.swift, handles the vote calls likeandunlike func
                self.heartImageview.image = UIImage(named: "empty-heart")
                self.post.likeAndUnlike(true)
                self.likeRef.setValue(true)
            } else {
                self.heartImageview.image = UIImage(named: "filled-heart")
                self.post.likeAndUnlike(false)
                self.likeRef.removeValue()
            }
            
        })
    }
}
