//
//  Stack.swift
//  Task
//
//  Created by Caleb Hicks on 10/21/15.
//  Copyright © 2015 DevMountain. All rights reserved.
//

import Foundation
import CoreData

class Stack {
    
    static let sharedStack = Stack()
    
    lazy var managedObjectContext: NSManagedObjectContext = Stack.setUpMainContext()
    
    static func setUpMainContext() -> NSManagedObjectContext {
        let bundle = Bundle.main
        guard let model = NSManagedObjectModel.mergedModel(from: [bundle])
            else { fatalError("model not found") }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil,
            at: storeURL(), options: nil)
        let context = NSManagedObjectContext(
            concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        return context
    }
    
    static func storeURL () -> URL? {
        let documentsDirectory: URL?
        do {
            documentsDirectory = try FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
        } catch {
            documentsDirectory = nil
        }
        
        return documentsDirectory?.appendingPathComponent("db.sqlite")
    }

}
