//
//  ColorsDictionary.swift
//  YarnClone
//
//  Created by Nadezhda Demidovich on 9/3/17.
//  Copyright © 2017 Nadezhda Demidovich. All rights reserved.
//

import UIKit

struct MessageColorSettings{
    let backgroundColor : UIColor
    let senderNameColor : UIColor
}

//Colors provided for max 4 persons in story
struct ColorsDictionary {
    static let colorsDictionary : [Int: MessageColorSettings] = [
        0: MessageColorSettings(backgroundColor: UIColor(red: 243 / 255.0, green: 219 / 255.0, blue: 243 / 255.0, alpha: 1.0), senderNameColor: UIColor(red: 230 / 255.0, green: 106 / 255.0, blue: 172 / 255.0, alpha: 1.0)),
        1: MessageColorSettings(backgroundColor: UIColor(red: 203 / 255.0, green: 238 / 255.0, blue: 250 / 255.0, alpha: 1.0), senderNameColor: UIColor(red: 22 / 255.0, green: 116 / 255.0, blue: 209 / 255.0, alpha: 1.0)),
        2: MessageColorSettings(backgroundColor: .gray, senderNameColor: .green),
        3: MessageColorSettings(backgroundColor: .yellow, senderNameColor: .black),]
}
