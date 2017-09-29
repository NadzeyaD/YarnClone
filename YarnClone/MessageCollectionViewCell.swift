//
//  MessageCollectionViewCell.swift
//  YarnClone
//
//  Created by Nadezhda Demidovich on 9/3/17.
//  Copyright © 2017 Nadezhda Demidovich. All rights reserved.
//

import UIKit

class MessageCollectionViewCell: UICollectionViewCell {
    
    //MARK : Properties
    var authorNameLabel = UILabel()
    var messageLabel = UILabel()
    
    var divisionLabel = UILabel(frame: .zero)
    
    //MARK : Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(authorNameLabel)
        self.contentView.addSubview(messageLabel)
        self.contentView.addSubview(divisionLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK : Functions
    func configureViews(){
        contentView.layer.cornerRadius = 5
        
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.sizeToFit()
        messageLabel.textColor = .black
        messageLabel.font = UIFont.systemFont(ofSize: 14.0)
        
        authorNameLabel.sizeToFit()
        authorNameLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        
        divisionLabel.font = UIFont.systemFont(ofSize: 14.0)
    }

    override func layoutSubviews(){
        configureViews()
        authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        divisionLabel.translatesAutoresizingMaskIntoConstraints = false

        authorNameLabel.addTopConstraint(toView: contentView, attribute: .top, relation: .equal, constant: 5)
        authorNameLabel.addLeftConstraint(toView: contentView, attribute: .left, relation: .equal, constant: 15)
        authorNameLabel.addHeightConstraint(toView: nil, relation: .equal, constant: 15)
        authorNameLabel.addRightConstraint(toView: contentView, attribute: .right, relation: .lessThanOrEqual, constant: -15)
        
        messageLabel.addLeftConstraint(toView: contentView, attribute: .left, relation: .equal, constant: 15)
        messageLabel.addTopConstraint(toView: authorNameLabel, attribute: .bottom, relation: .equal, constant: 5)
        messageLabel.addRightConstraint(toView: contentView, attribute: .right, relation: .equal, constant: -15)
        messageLabel.addBottomConstraint(toView: contentView, attribute: .bottom, relation: .equal, constant: -5)
        
        divisionLabel.addCenterXConstraint(toView: contentView)
        divisionLabel.addCenterYConstraint(toView: contentView)
    }

}
