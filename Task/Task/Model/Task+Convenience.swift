//
//  Task+Convenience.swift
//  Task
//
//  Created by Connor Holland on 6/11/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import Foundation
import CoreData

extension Task {
    @discardableResult
    convenience init (name: String, notes: String?, due: Date?) {
        self.init(context: CoreDataStack.context)
        self.name = name
        self.notes = notes
        self.due = due
    }
}
