//
//  Task+CoreDataProperties.swift
//  Task
//
//  Created by Caleb Hicks on 10/21/15.
//  Copyright © 2015 DevMountain. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Task {
	
	@NSManaged var due: NSDate?
	@NSManaged var isComplete: NSNumber
	@NSManaged var name: String
	@NSManaged var notes: String?
	@NSManaged var priority: String
	
}
