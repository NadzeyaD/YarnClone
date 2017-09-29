//
//  StoryHeaderView.swift
//  YarnClone
//
//  Created by Nadezhda Demidovich on 9/4/17.
//  Copyright © 2017 Nadezhda Demidovich. All rights reserved.
//

import UIKit

class StoryHeaderView: UIView {

    //MARK : Properties
    var storyNameLabel = UILabel()
    var closeButton = UIButton()
    var authorNameLabel = UILabel()
    
    //MARK : Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        
        self.addSubview(storyNameLabel)
        self.addSubview(closeButton)
        self.addSubview(authorNameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //MARK : Functions
    func configureViews(){
        self.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        
        storyNameLabel.textColor = .black
        storyNameLabel.font = UIFont.systemFont(ofSize: 14.0)
        
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.lightGray, for: .normal)
        closeButton.tintColor = .lightGray
        
        authorNameLabel.textColor = UIColor(red: 21 / 255.0, green: 90 / 255.0, blue: 104 / 255.0, alpha: 1.0)
        authorNameLabel.font = UIFont.boldSystemFont(ofSize: 11.0)
        
    }
    override func layoutSubviews() {
        
        configureViews()
        storyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        storyNameLabel.addLeftConstraint(toView: self, attribute: .left, relation: .equal, constant: 15)
        storyNameLabel.addWidthConstraint(toView: nil, relation: .lessThanOrEqual, constant: self.frame.width)
        storyNameLabel.addRightConstraint(toView: closeButton, attribute: .left, relation: .equal, constant: -15)
        storyNameLabel.addTopConstraint(toView: self, attribute: .top, relation: .equal, constant: 15)
        
        authorNameLabel.addLeftConstraint(toView: self, attribute: .left, relation: .equal, constant: 15)
        authorNameLabel.addWidthConstraint(toView: nil, relation: .lessThanOrEqual, constant: self.frame.width)
        authorNameLabel.addTopConstraint(toView: storyNameLabel, attribute: .bottom, relation: .equal, constant: 5)
        
        closeButton.addWidthConstraint(toView: nil, relation: .equal, constant: 30)
        closeButton.addRightConstraint(toView: self, attribute: .right, relation: .equal, constant: -15)
        closeButton.addTopConstraint(toView: self, attribute: .top, relation: .equal, constant: 15)
        closeButton.addHeightConstraint(toView: nil, relation: .equal, constant: 30)
        
    }
}
