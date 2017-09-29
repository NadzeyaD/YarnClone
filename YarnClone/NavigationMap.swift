//
//  NavigationMap.swift
//  YarnClone
//
//  Created by Nadezhda Demidovich on 9/3/17.
//  Copyright © 2017 Nadezhda Demidovich. All rights reserved.
//

import URLNavigator

struct NavigationMap {
    
    static func setup() {
        Navigator.scheme = "YarnClone"
        Navigator.map("navigator://story/<storyUrl>", StoryViewController.self)
    }
}
