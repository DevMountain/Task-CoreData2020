//
//  TaskController.swift
//  Task
//
//  Created by Caleb Hicks on 10/20/15.
//  Copyright © 2015 DevMountain. All rights reserved.
//

import Foundation
import CoreData

class TaskController {

    static let sharedController = TaskController()
    
    var mockTasks:[Task] {
        let sampleTask1 = Task(name: "Go grocery shopping", notes: "Costco")
        let sampleTask2 = Task(name: "Pay rent", notes: "344 South State Street, SLC, Utah", due: Date(timeIntervalSinceNow: TimeInterval(60*60*24*3)))
        let sampleTask3 = Task(name: "Finish work project")
        let sampleTask4 = Task(name: "Install new light fixture", notes: "Downstairs bathroom")
        sampleTask4.isComplete = true
        let sampleTask5 = Task(name: "Order pizza")
        sampleTask5.isComplete = true
        
        return [sampleTask1, sampleTask2, sampleTask3, sampleTask4]
    }
    
    let fetchedResultsController: NSFetchedResultsController<Task>

    init() {
		let request: NSFetchRequest<Task> = NSFetchRequest<Task>(entityName: "Task")
        let completedSortDescriptor = NSSortDescriptor(key: "isComplete", ascending: true)
        let dueSortDescriptor = NSSortDescriptor(key: "due", ascending: true)
        request.sortDescriptors = [completedSortDescriptor, dueSortDescriptor]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: Stack.sharedStack.managedObjectContext, sectionNameKeyPath: "isComplete", cacheName: nil)
        do { 
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Unable to perform fetch request: \(error.localizedDescription)")
        }
    }
    
    func addTask(_ name: String, notes: String?, due: Date?) {
        let _ = Task(name: name, notes: notes, due: due)
        saveToPersistentStorage()
    }
    
    func updateTask(_ task: Task, name: String, notes: String?, due: Date?) {
        task.name = name
        task.notes = notes
        task.due = due
        saveToPersistentStorage()
    }
    
    func removeTask(_ task: Task) {
        
        task.managedObjectContext?.delete(task)
        saveToPersistentStorage()
    }
    
    func isCompleteValueToggle(_ task: Task) {
        task.isComplete = !task.isComplete.boolValue as NSNumber
        saveToPersistentStorage()
    }
    
    // MARK: - Persistence
    
    func saveToPersistentStorage() {
        
        do {
            try Stack.sharedStack.managedObjectContext.save()
        } catch {
            print("Error saving Managed Object Context. Items not saved.")
        }
    }
}
