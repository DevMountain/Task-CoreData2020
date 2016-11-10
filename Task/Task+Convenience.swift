//
//  Task+Convenience.swift
//  Task
//
//  Created by Andrew Madsen on 10/6/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation
import CoreData

extension Task {
	convenience init(name: String, notes: String? = nil, due: Date? = nil, context: NSManagedObjectContext = CoreDataStack.context) {
		
		self.init(context: context)
		
		self.name = name
		self.notes = notes
		self.due = due as NSDate?
		self.isComplete = false
	}
}
