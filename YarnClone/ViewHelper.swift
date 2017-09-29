//
//  ViewHelper.swift
//  YarnClone
//
//  Created by Nadezhda Demidovich on 9/5/17.
//  Copyright © 2017 Nadezhda Demidovich. All rights reserved.
//

import UIKit

struct ViewHelper {
    static func heightForView(text: String, font: UIFont, width: CGFloat) -> CGSize {
        let label : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.size
    }
}
