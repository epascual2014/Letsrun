//
//  Extensions.swift
//  Letsrun
//
//  Created by Edrick Pascual on 7/27/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import UIKit

// Cache images serves as memory bank for all the images
let imageCache = NSCache()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        // Check cache for image first
        if let cachedImage = imageCache.objectForKey(urlString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // Otherwise fire off a new image
        let url = NSURL(string: urlString)
        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                
                // Need to do this if let statement since setObject requires a nonoptional image
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString)
                    
                    self.image = downloadedImage
                }
            })
        }).resume()
    }
}

