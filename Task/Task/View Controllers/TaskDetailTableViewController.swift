//
//  TaskDetailTableViewController.swift
//  Task
//
//  Created by Karl Pfister on 11/11/19.
//  Copyright © 2019 Karl Pfister. All rights reserved.
//

import UIKit

class TaskDetailTableViewController: UITableViewController {


    //outlets for detail view
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDueTextField: UITextField!
    @IBOutlet var dueDatePicker: UIDatePicker!
    @IBOutlet weak var taskNotesTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        taskDueTextField.inputView = dueDatePicker
        updateViews()
    }

    var task: Task?

    var dueDateValue: Date?

    private func updateViews() {
        guard let task = task, isViewLoaded else { return }
        title = task.name
        taskNameTextField.text = task.name
        taskDueTextField.text = (task.due as Date?)?.stringValue()
        taskNotesTextView.text = task.notes

    }

    @IBAction func saveButtonTapped(_ sender: Any) {

        guard let name = taskNameTextField.text, let notes = taskNotesTextView.text, let date = dueDateValue else { return }

        if let task = task {
            // update
            TaskController.shared.update(task: task, name: name, notes: notes, due: date)
        } else {
            // create
            TaskController.shared.add(taskWithName: name, notes: notes, due: date)
        }
        navigationController?.popViewController(animated: true)
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        self.taskDueTextField.text = sender.date.stringValue()
        self.dueDateValue = sender.date
    }

    @IBAction func userTappedView(_ sender: Any) {
        self.taskNameTextField.resignFirstResponder()
        self.taskDueTextField.resignFirstResponder()
        self.taskNotesTextView.resignFirstResponder()
    }

} // class end bracket
