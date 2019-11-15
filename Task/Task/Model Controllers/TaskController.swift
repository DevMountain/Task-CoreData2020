//
//  TaskController.swift
//  Task
//
//  Created by Karl Pfister on 11/11/19.
//  Copyright © 2019 Karl Pfister. All rights reserved.
//

import Foundation
import CoreData

class TaskController {

    //MARK:- Singleton

    static let shared = TaskController()
    // MARK:- Property
    /**
     Source of Truth

     Creates an array of Task Objects and the value to either the results of a fetchRequest or an empty array
     - fetchRequest: We set our fetchRequest to be *of type* a `NSFetchRequest` that can interact with `Task` objects

     - returns: The results of our fetch request *or* an empty array
     */

    var tasks: [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        return (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
    }

    //MARK: - CRUD

    // Create
    /**
     Creates a Task object and calls the `saveToPersistentStore()` method to save it to persistent storage

     - Parameters:
        - name: String value to be passed into the Task initializer's name parameter
        - notes: String value to be passed into the Task initializer's notes parameter
        - due: Date value to be passed into the Task initializer's date parameter
     */
    func add(taskWithName name: String, notes: String, due: Date) {
        // Do not need to assign this to a property because the initalizer is marked @discardableResult
        Task(name: name, notes: notes, due: due)
        saveToPersistentStore() // defined below
    }

    // Update
    /**
     Updates an existing Task object in persistent storage and and calls the `saveToPersistentStore()` method to save it with the updated values

     - Parameters:
        - task: The Task that needs to be updated
        - name: String value to replace the Task's current name
        - notes: String value to replace the Task's current notes
        - due: Date value to replace the Task's current date
     */
    func update(task: Task, name: String, notes: String, due: Date) {
        task.name = name
        task.notes = notes
        task.due = due

        saveToPersistentStore()
    }

    /**
     Toggles a Task object's isComplete boolean value and and calls the `saveToPersistentStore()` method to save it to persistent storage with the updated value

     - Parameters:
        - task: The Task that is being updated
     */
    func toggleIsCompleteFor(task: Task) {
        // Update the isComplete Property on the task to the opposite state
        task.isComplete = !task.isComplete
        // I want this in the Model Controller because the isComplete is a property on my model.
        saveToPersistentStore()
    }

    // Delete
    /**
     Removes an existing Task object from the CoreDataStack context by calling the `delete()` method and then saves the context changes by calling `saveToPersistentStore()`

     - Parameters:
        - task: The Task to be removed from storage
     */
    func remove(task: Task) {
        CoreDataStack.context.delete(task)
        saveToPersistentStore()
    }

    /**
     Saves the current CoreDataStack's context to persistent storage by calling the `save()` method
     */
    private func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error saving Managed Object Context, item not saved")
        }
    }
}
