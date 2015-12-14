//
//  TaskListTableViewController.swift
//  Task
//
//  Created by Caleb Hicks on 10/20/15.
//  Copyright © 2015 DevMountain. All rights reserved.
//

import UIKit
import CoreData

class TaskListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
	
	lazy var fetchedResultsController: NSFetchedResultsController = {
		let context = Stack.sharedStack.managedObjectContext
		let fetchRequest = NSFetchRequest(entityName: "Task")
		let sortDescriptor = NSSortDescriptor(key: "due", ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "priority", cacheName: nil)
		frc.delegate = self
		return frc
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		do {
			try fetchedResultsController.performFetch()
		} catch let error as NSError {
			NSLog("Error performing fetch on NSFetchedResultsController: \(error)")
		}
	}
	
	override func viewDidAppear(animated: Bool) {
		
		tableView.reloadData()
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		guard let sections = fetchedResultsController.sections else { return 0 }
		return sections.count
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let sections = fetchedResultsController.sections where sections.count > section else { return 0 }
		return sections[section].numberOfObjects
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard let sections = fetchedResultsController.sections where sections.count > section else { return nil }
		return sections[section].name
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as! ButtonTableViewCell
		
		if let task = fetchedResultsController.objectAtIndexPath(indexPath) as? Task {
			cell.updateWithTask(task)
			cell.delegate = self
		}
		
		return cell
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
		
			guard let task = fetchedResultsController.objectAtIndexPath(indexPath) as? Task else { return }
			let moc = Stack.sharedStack.managedObjectContext
			moc.deleteObject(task)
		}
	}
	
	// MARK: - NSFetchedResultsControllerDelegate
	
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		tableView.reloadData()
	}
	
	// MARK: - Navigation
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if segue.identifier == "toViewTask" {
			
			let destinationViewController = segue.destinationViewController as? TaskDetailTableViewController
			
			if let taskDetailViewController = destinationViewController {
				
				// force the destination view controller to draw all subviews for updating
				_ = taskDetailViewController.view
				
				if let indexPath = tableView.indexPathForSelectedRow,
					task = fetchedResultsController.objectAtIndexPath(indexPath) as? Task {
						taskDetailViewController.updateWithTask(task)
				}
			}
		}
	}
}

extension TaskListTableViewController: ButtonTableViewCellDelegate {
	
	func buttonCellButtonTapped(sender: ButtonTableViewCell) {
		
		guard let indexPath = tableView.indexPathForCell(sender),
			task = fetchedResultsController.objectAtIndexPath(indexPath) as? Task else { return }
		
		task.isComplete = !task.isComplete.boolValue
		let _ = try? Stack.sharedStack.managedObjectContext.save()
		
		tableView.reloadData()
	}
}
