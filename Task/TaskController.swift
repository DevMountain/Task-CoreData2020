//
//  TaskController.swift
//  Task
//
//  Created by Caleb Hicks on 10/20/15.
//  Copyright © 2015 DevMountain. All rights reserved.
//

import Foundation

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
        
        return tasks.filter({$0.isComplete})
    }
    
    var incompleteTasks:[Task] {
        
        return tasks.filter({!$0.isComplete})
    }
    
    init() {
        
        // uncomment the next line to initialize with mock task data
        // tasks = mockTasks
        
        loadFromPersistentStorage()
    }
    
    func addTask(task: Task) {
        
        tasks.append(task)
        saveToPersistentStorage()
    }
    
    func removeTask(task: Task) {
        
        if let index = self.tasks.indexOf(task) {
            tasks.removeAtIndex(index)
        }
        saveToPersistentStorage()
    }
    
    // MARK: - Persistence
    
    func loadFromPersistentStorage() {
        
        let unarchivedTasks = NSKeyedUnarchiver.unarchiveObjectWithFile(self.filePath(TaskKey))
        
        if let tasks = unarchivedTasks as? [Task] {
            self.tasks = tasks
        }
    }
    
    func saveToPersistentStorage() {
        
        NSKeyedArchiver.archiveRootObject(self.tasks, toFile: self.filePath(TaskKey))
    }
    
    func filePath(key: String) -> String {
        let directorySearchResults = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.AllDomainsMask, true)
        let documentsPath: AnyObject = directorySearchResults[0]
        let entriesPath = documentsPath.stringByAppendingString("/\(key).plist")
        
        return entriesPath
    }
}