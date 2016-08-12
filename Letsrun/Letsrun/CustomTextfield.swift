//
//  CustomTextfield.swift
//  Letsrun
//
//  Created by Edrick Pascual on 8/11/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import Foundation

class CustomTextfield: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: SHADOW_GRAY).CGColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 2.0
        
        
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
}
