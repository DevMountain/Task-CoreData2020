//
//  DateHelper.swift
//  Task
//
//  Created by Karl Pfister on 11/11/19.
//  Copyright © 2019 Karl Pfister. All rights reserved.
//

import Foundation
extension Date {

    /**
     Sets Formatting for out dates. Returns a String

     ## Important Notes ##
     1. This extends a Date; so it is usable on all Date objects
     2. Currently Set to medium Date length
     */
    func stringValue() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}
