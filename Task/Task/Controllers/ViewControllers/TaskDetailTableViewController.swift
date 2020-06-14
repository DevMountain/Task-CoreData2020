//
//  TaskDetailTableViewController.swift
//  Task
//
//  Created by Connor Holland on 6/11/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import UIKit

class TaskDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var dueTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet var dueDatePicker: UIDatePicker!
    
    
    var task: Task?
    var dueDateValue: Date?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        dueTextField.inputView = dueDatePicker

    }
    
    //Actions
    //Come back to this
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = taskNameTextField.text, !name.isEmpty, let noteText = noteTextView.text, !noteText.isEmpty, let due = dueDateValue else {return}
        if let task = task {
            TaskController.shared.update(task: task, name: name, notes: noteText, due: due)
        } else {
            TaskController.shared.add(taskWithName: name, notes: noteText, due: due)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        dueDateValue = dueDatePicker.date
        dueTextField.text = dueDateValue?.stringValue()
    }
    
    @IBAction func userTappedView(_ sender: UITapGestureRecognizer) {
        dueTextField.resignFirstResponder() 
    }
    
    
    
    func updateViews() {
        taskNameTextField.text = task?.name
        dueTextField.text = task?.due?.stringValue()
        noteTextView.text = task?.notes
        self.dueDateValue = task?.due
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

}
