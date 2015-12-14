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
    
    private let TaskKey = "tasks"
    
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
	
	private func tasksWithPredicate(predicate: NSPredicate?) -> [Task] {
		let request = NSFetchRequest(entityName: "Task")
		request.predicate = predicate
		request.sortDescriptors = [NSSortDescriptor(key: "due", ascending: true)]
		do {
			let moc = Stack.sharedStack.managedObjectContext
			return try moc.executeFetchRequest(request) as! [Task]
		} catch {
			return []
		}
	}
	
    var tasks:[Task] {
		return tasksWithPredicate(nil)
    }
    
    var completedTasks:[Task] {
		return tasksWithPredicate(NSPredicate(format: "isComplete == TRUE"))
    }
    
    var incompleteTasks:[Task] {
		return tasksWithPredicate(NSPredicate(format: "isComplete == FALSE"))
    }
	
    func addTask(task: Task) {
        
        saveToPersistentStorage()
    }
    
    func removeTask(task: Task) {
        
        task.managedObjectContext?.deleteObject(task)
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
    
    func filePath(key: String) -> String {
        let directorySearchResults = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.AllDomainsMask, true)
        let documentsPath: AnyObject = directorySearchResults[0]
        let entriesPath = documentsPath.stringByAppendingString("/\(key).plist")
        
        return entriesPath
    }
}