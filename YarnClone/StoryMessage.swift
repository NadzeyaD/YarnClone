//
//  StoryMessage.swift
//  YarnClone
//
//  Created by Nadezhda Demidovich on 9/3/17.
//  Copyright © 2017 Nadezhda Demidovich. All rights reserved.
//

import Foundation
import ObjectMapper

enum MessageType{
    case simple, startBreak, divider
}

class StoryMessage : Mappable {
    
    var message : String?
    var author : String?
    var breakMessage : String?
    var dividerMessage : String?
    var isShown : Bool = false
    var messageType : MessageType {
        get {
            if message != nil {
                return .simple
            } else if breakMessage != nil {
                return .startBreak }
                    else {
                        return .divider
                }
        }
    }
    
    
    //MARK: Inits
    required init?(map: Map){
    }
    
    //MARK : Functions
    func mapping(map: Map) {
        message <- map["message"]
        author <- map["author"]
        breakMessage <- map["breakMessage"]
        dividerMessage <- map["dividerMessage"]
    }

}
