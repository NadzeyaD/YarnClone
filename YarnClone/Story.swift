//
//  Story.swift
//  YarnClone
//
//  Created by Nadezhda Demidovich on 9/3/17.
//  Copyright © 2017 Nadezhda Demidovich. All rights reserved.
//

import ObjectMapper

class Story : StoryHeader {
    
    var id : Int
    var messages : [StoryMessage]
    
    //MARK: Inits
    required init?(map: Map){
        self.id = 0
        self.messages = [StoryMessage]()
        super.init(map: map)
    }
    
    //MARK : Functions
    override func mapping(map: Map) {
        super.mapping(map: map)
        id <- map["id"]
        messages <- map["messages"]
    }
}
