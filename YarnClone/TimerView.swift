//
//  TimerView.swift
//  YarnClone
//
//  Created by Nadezhda Demidovich on 9/4/17.
//  Copyright © 2017 Nadezhda Demidovich. All rights reserved.
//

import UIKit

class TimerView: UIView {

    //MARK : Properties
    var imageBackgroundView = UIImageView()
    var nextEpisodeInLabel = UILabel()
    var countDownLabel = UILabel()
    var skipButton = UIButton()
    
    //MARK : Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.self.backgroundColor = .black
        countDownLabel.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        self.addSubview(imageBackgroundView)
        self.addSubview(nextEpisodeInLabel)
        self.addSubview(countDownLabel)
        self.addSubview(skipButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //MARK : Functions
    func configureViews(){
        self.backgroundColor = .darkGray
        countDownLabel.textColor = .white
        countDownLabel.numberOfLines = 1
        countDownLabel.textAlignment = .center
        countDownLabel.textColor = .white
        countDownLabel.font = UIFont.boldSystemFont(ofSize: 24.0)
        countDownLabel.layer.cornerRadius = self.countDownLabel.frame.size.width / 2
        countDownLabel.layer.borderColor = UIColor.white.cgColor
        countDownLabel.layer.borderWidth = 1

        nextEpisodeInLabel.text = "Next episode in..."
        nextEpisodeInLabel.textColor = .white
        nextEpisodeInLabel.textAlignment = .center
        
        skipButton.backgroundColor = .blue
        skipButton.setTitle("Skip...", for: .normal)
    }
    
    override func layoutSubviews() {
        configureViews()
        
        countDownLabel.translatesAutoresizingMaskIntoConstraints = false
        nextEpisodeInLabel.translatesAutoresizingMaskIntoConstraints = false
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        
        countDownLabel.addCenterXConstraint(toView: self)
        countDownLabel.addCenterYConstraint(toView: self)
        countDownLabel.addWidthConstraint(toView: nil, relation: .equal, constant: 80)
        countDownLabel.addHeightConstraint(toView: nil, relation: .equal, constant: 80)
        
        nextEpisodeInLabel.addCenterXConstraint(toView: self)
        nextEpisodeInLabel.addTopConstraint(toView: self, attribute: .top, relation: .equal, constant: 20)
        
        skipButton.addBottomConstraint(toView: self, attribute: .bottom, relation: .equal, constant: 0)
        skipButton.addHeightConstraint(toView: nil, relation: .equal, constant: 40)
        skipButton.addLeftConstraint(toView: self, attribute: .left, relation: .equal, constant: 0)
        skipButton.addRightConstraint(toView: self, attribute: .right, relation: .equal, constant: 0)
    }

}








