//
//  DateHelpers.swift
//  Task
//
//  Created by Caleb Hicks on 10/19/15.
//  Copyright © 2015 DevMountain. All rights reserved.
//

import Foundation

extension Date {
    
    func stringValue() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        return formatter.string(from: self)
    }

}
