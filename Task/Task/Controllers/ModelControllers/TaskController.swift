//
//  TaskController.swift
//  Task
//
//  Created by Connor Holland on 6/11/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import Foundation
import CoreData

class TaskController {
    
    static let shared = TaskController()
    
    //Source of truth
    
    var fetchedResultsController: NSFetchedResultsController<Task>
    
    init() {
        let fetchedRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        fetchedRequest.sortDescriptors = [NSSortDescriptor(key: "isComplete", ascending: true), NSSortDescriptor(key: "due", ascending: true)]
      
        
        
        let resultsController = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isComplete", cacheName: nil)
        fetchedResultsController = resultsController
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
   
    
    // MARK: - CRUD Methods
    
    //create
    func add(taskWithName name: String, notes: String?, due: Date?) {
        Task(name: name, notes: notes, due: due)
        saveToPersistenceStore()
    }
    
    //update
    func update(task: Task, name: String, notes: String, due: Date) {
        task.name = name
        task.notes = notes
        task.due = due
        saveToPersistenceStore()
    }
    
    //delete
    func delete(task: Task) {
        task.managedObjectContext?.delete(task)
        saveToPersistenceStore()
    }
    
    func toggleIsComplete(task: Task) {
        task.isComplete = !task.isComplete
        saveToPersistenceStore()
    }
    
    
    
    func saveToPersistenceStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("There was an error in \(#function): \(error) - \(error.localizedDescription)")
        }
    }
}
