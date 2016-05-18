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
    
    var tasks:[Task] = []
    
    var completedTasks:[Task] {
        
        return tasks.filter({$0.isComplete.boolValue})
    }
    
    var incompleteTasks:[Task] {
        
        return tasks.filter({!$0.isComplete.boolValue})
    }
    
    init() {
        self.tasks = fetchTasks()
    }
    
    func addTask(name: String, notes: String?, due: NSDate?) {
        let _ = Task(name: name, notes: notes, due: due)
        saveToPersistentStorage()
        tasks = fetchTasks()
    }
    
    func updateTask(task: Task, name: String, notes: String?, due: NSDate?) {
        task.name = name
        task.notes = notes
        task.due = due
        saveToPersistentStorage()
        tasks = fetchTasks()
    }
    
    func removeTask(task: Task) {
        
        task.managedObjectContext?.deleteObject(task)
        saveToPersistentStorage()
        tasks = fetchTasks()
    }
    
    func isCompleteValueToggle(task: Task) {
        task.isComplete = !task.isComplete.boolValue
        saveToPersistentStorage()
        tasks = fetchTasks()
    }
    
    // MARK: - Persistence
    
    func saveToPersistentStorage() {
        
        do {
            try Stack.sharedStack.managedObjectContext.save()
        } catch {
            print("Error saving Managed Object Context. Items not saved.")
        }
    }
    
    func fetchTasks() -> [Task] {
        let request = NSFetchRequest(entityName: "Task")
        
        let tasks = (try? Stack.sharedStack.managedObjectContext.executeFetchRequest(request)) as? [Task]
        return tasks ?? []
    }
}