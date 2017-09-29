//
//  StoryView.swift
//  YarnClone
//
//  Created by Nadezhda Demidovich on 9/4/17.
//  Copyright © 2017 Nadezhda Demidovich. All rights reserved.
//

import UIKit

class StoryView: UIView {

    //MARK : Properties
    var coverImageView = UIImageView()
    var storyNameLabel = UILabel()
    var descriptionLabel = UILabel()
    var progressView = UIProgressView()
    var backgroundView = UIView()
    
    //MARK : Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.self.backgroundColor = .black
        
        self.addSubview(coverImageView)
        self.addSubview(progressView)
        self.addSubview(backgroundView)
        self.addSubview(descriptionLabel)
        self.addSubview(storyNameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK : Functions
    func configureViews(){
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.sizeToFit()
        descriptionLabel.backgroundColor = .clear

        storyNameLabel.textColor = UIColor.white.withAlphaComponent(1)
        storyNameLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        progressView.progressTintColor = .green
    }
    
    override func layoutSubviews() {
        configureViews()
        coverImageView.frame = self.bounds
        
        storyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.addLeftConstraint(toView: self, attribute: .left, relation: .equal, constant: 15)
        descriptionLabel.addWidthConstraint(toView: nil, relation: .lessThanOrEqual, constant: self.frame.width)
        descriptionLabel.addRightConstraint(toView: self, attribute: .right, relation: .equal, constant: -15)
        descriptionLabel.addBottomConstraint(toView: self, attribute: .bottom, relation: .equal, constant: -15)
        
        storyNameLabel.addLeftConstraint(toView: self, attribute: .left, relation: .equal, constant: 15)
        storyNameLabel.addWidthConstraint(toView: nil, relation: .lessThanOrEqual, constant: self.frame.width)
        storyNameLabel.addRightConstraint(toView: self, attribute: .right, relation: .equal, constant: -15)
        storyNameLabel.addBottomConstraint(toView: descriptionLabel, attribute: .top, relation: .equal, constant: -5)
        
        backgroundView.addLeftConstraint(toView: self, attribute: .left, relation: .equal, constant: 0)
        backgroundView.addWidthConstraint(toView: nil, relation: .lessThanOrEqual, constant: self.frame.width)
        backgroundView.addRightConstraint(toView: self, attribute: .right, relation: .equal, constant: 0)
        backgroundView.addBottomConstraint(toView: self, attribute: .bottom, relation: .equal, constant: 0)
        backgroundView.addTopConstraint(toView: storyNameLabel, attribute: .top, relation: .equal, constant: -15)
        
        progressView.addLeftConstraint(toView: self, attribute: .left, relation: .equal, constant: 0)
        progressView.addRightConstraint(toView: self, attribute: .right, relation: .equal, constant: 0)
        progressView.addBottomConstraint(toView: self, attribute: .bottom, relation: .equal, constant: 0)
        progressView.addHeightConstraint(toView: nil, relation: .equal, constant: 3)
        
    }

}
