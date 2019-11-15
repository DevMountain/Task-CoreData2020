//
//  Task+Convenience.swift
//  Task
//
//  Created by Karl Pfister on 11/11/19.
//  Copyright © 2019 Karl Pfister. All rights reserved.
//

import Foundation
import CoreData

extension Task {
    /// `@discarableResult` indicates we have the option of ignoring the returned value from the initializer
    @discardableResult
    /**
     Initializes a Task object from a context

     - Parameters:
        - name: String value for the name attribute
        - notes Optional String value for the notes attribute, default value of nil
        - due: Optional date value for the due attribute, default value of nil
        - context: The NSManagedObjectContext for the app, default value set to the CoreDataStack class's context property
     */
    convenience init(name: String, notes: String? = nil, due: Date? = nil, context: NSManagedObjectContext = CoreDataStack.context) {
        //convenience initializer for the task format
        self.init(context: context)

        self.name = name
        self.notes = notes
        self.due = due
        self.isComplete = false
    }
}
