//
//  Extensions.swift
//  YarnClone
//
//  Created by Nadezhda Demidovich on 9/5/17.
//  Copyright © 2017 Nadezhda Demidovich. All rights reserved.
//

import UIKit

public let mainDateFormat = "dd.MM.yyyy"

extension String {
    func toDate( dateFormat format  : String ) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
}

extension Date {
    func toString( dateFormat format  : String ) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension Int {
    func getTimerString() -> String {
        let minutes = String(self / 60)
        let seconds = String(self % 60)
        return minutes + ":" + seconds
    }
}

extension Array where Element : Hashable {
    var unique: [Element] {
        return Array(Set(self))
    }
}
