//
//  CoreDataStack.swift
//  Task
//
//  Created by Connor Holland on 6/11/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStack {
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Task") //<--- Change to name of app
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("\(error.localizedDescription)")
            }
        }
        return container
    }()
    static var context: NSManagedObjectContext {
        return container.viewContext
    }
}
