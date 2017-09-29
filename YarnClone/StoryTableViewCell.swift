//
//  StoryTableViewCell.swift
//  YarnClone
//
//  Created by Nadezhda Demidovich on 9/3/17.
//  Copyright © 2017 Nadezhda Demidovich. All rights reserved.
//

import UIKit
import AutoLayoutHelperSwift

class StoryTableViewCell: UITableViewCell {
    
    //MARK : Properties
    var storyView = StoryView()

    //MARK : Inits
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(storyView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK : Functions
    override func layoutSubviews(){
        storyView.frame = contentView.bounds
    }
    
}
