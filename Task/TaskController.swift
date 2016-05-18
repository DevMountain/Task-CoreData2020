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
        let sampleTask2 = Task(name: "Pay rent", notes: "344 South State Street, SLC, Utah", due: NSDate(timeIntervalSinceNow: NSTimeInterval(60*60*24*3)))
        let sampleTask3 = Task(name: "Finish work project")
        let sampleTask4 = Task(name: "Install new light fixture", notes: "Downstairs bathroom")
        sampleTask4.isComplete = true
        let sampleTask5 = Task(name: "Order pizza")
        sampleTask5.isComplete = true
        
        return [sampleTask1, sampleTask2, sampleTask3, sampleTask4]
    }
    
    let fetchedResultsController: NSFetchedResultsController

    init() {
        let request = NSFetchRequest(entityName: "Task")
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
    
    func addTask(name: String, notes: String?, due: NSDate?) {
        let _ = Task(name: name, notes: notes, due: due)
        saveToPersistentStorage()
    }
    
    func updateTask(task: Task, name: String, notes: String?, due: NSDate?) {
        task.name = name
        task.notes = notes
        task.due = due
        saveToPersistentStorage()
    }
    
    func removeTask(task: Task) {
        
        task.managedObjectContext?.deleteObject(task)
        saveToPersistentStorage()
    }
    
    func isCompleteValueToggle(task: Task) {
        task.isComplete = !task.isComplete.boolValue
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