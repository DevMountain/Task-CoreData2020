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
	
    init() {
		let request: NSFetchRequest<Task> = Task.fetchRequest()
        let completedSortDescriptor = NSSortDescriptor(key: "isComplete", ascending: true)
        let dueSortDescriptor = NSSortDescriptor(key: "due", ascending: true)
        request.sortDescriptors = [completedSortDescriptor, dueSortDescriptor]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                   managedObjectContext: CoreDataStack.context,
                                                                   sectionNameKeyPath: "isComplete",
                                                                   cacheName: nil)
        do { 
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to perform fetch request: \(error)")
        }
    }
	
	// MARK: Public
    
	func add(taskWithName name: String, notes: String?, due: Date?) {
        let _ = Task(name: name, notes: notes, due: due)
        saveToPersistentStorage()
    }
    
    func update(task: Task, name: String, notes: String?, due: Date?) {
        task.name = name
        task.notes = notes
        task.due = due as NSDate?
        saveToPersistentStorage()
    }
    
    func remove(task: Task) {
        task.managedObjectContext?.delete(task)
        saveToPersistentStorage()
    }
    
    func toggleIsCompleteFor(task: Task) {
        task.isComplete = !task.isComplete
        saveToPersistentStorage()
    }
    
    // MARK: Persistence
    
    private func saveToPersistentStorage() {
        
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error saving Managed Object Context. Items not saved.")
        }
    }
	
	// MARK: Properties
	
	let fetchedResultsController: NSFetchedResultsController<Task>

	var mockTasks: [Task] {
		let sampleTask1 = Task(name: "Go grocery shopping", notes: "Costco")
		let sampleTask2 = Task(name: "Pay rent", notes: "344 South State Street, SLC, Utah", due: Date(timeIntervalSinceNow: TimeInterval(60*60*24*3)))
		let sampleTask3 = Task(name: "Finish work project")
		let sampleTask4 = Task(name: "Install new light fixture", notes: "Downstairs bathroom")
		sampleTask4.isComplete = true
		let sampleTask5 = Task(name: "Order pizza")
		sampleTask5.isComplete = true
		
		return [sampleTask1, sampleTask2, sampleTask3, sampleTask4]
	}
}
