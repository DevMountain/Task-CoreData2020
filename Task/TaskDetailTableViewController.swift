//
//  TaskDetailTableViewController.swift
//  Task
//
//  Created by Caleb Hicks on 10/20/15.
//  Copyright © 2015 DevMountain. All rights reserved.
//

import UIKit

class TaskDetailTableViewController: UITableViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		taskDueTextField.inputView = dueDatePicker
		
		updateViews()
	}
	
	// MARK: Actions
	
	@IBAction func saveButtonTapped(_ sender: AnyObject) {
		updateTask()
		let _ = navigationController?.popViewController(animated: true)
	}
	
	@IBAction func cancelButtonTapped(_ sender: AnyObject) {
		let _ = navigationController?.popViewController(animated: true)
	}
	
	@IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
		
		self.taskDueTextField.text = sender.date.stringValue()
		self.dueDateValue = sender.date
	}
	
	@IBAction func userTappedView(_ sender: AnyObject) {
		
		self.taskNameTextField.resignFirstResponder()
		self.taskDueTextField.resignFirstResponder()
		self.taskNotesTextView.resignFirstResponder()
	}
	
	// MARK: Private
	
	private func updateTask() {
		
		guard let name = taskNameTextField.text else {return}
		let due = dueDateValue
		let notes = taskNotesTextView.text
		
		if let task = self.task {
			TaskController.sharedController.update(task: task, name: name, notes: notes, due: due)
		} else {
			TaskController.sharedController.add(taskWithName: name, notes: notes, due: due)
		}
	}
	
	private func updateViews() {
		guard let task = task, isViewLoaded else { return }
		
		title = task.name
		taskNameTextField.text = task.name
		taskDueTextField.text = task.due?.stringValue()
		taskNotesTextView.text = task.notes
	}
	
	// MARK: Properties
	
	var task: Task? {
		didSet {
			updateViews()
		}
	}
	
	var dueDateValue: Date?
	
	@IBOutlet weak var taskNameTextField: UITextField!
	@IBOutlet weak var taskDueTextField: UITextField!
	@IBOutlet weak var taskNotesTextView: UITextView!
	@IBOutlet var dueDatePicker: UIDatePicker!
}
